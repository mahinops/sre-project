package repository

import (
	"context"
	"fmt"

	"github.com/mokhlesurr031/sre-project/backend/domain"
	"gorm.io/gorm"
)

func New(db *gorm.DB) domain.ResourceRepository {
	return &ResourceSqlStorage{
		db: db,
	}
}

type ResourceSqlStorage struct {
	db *gorm.DB
}

func (resource *ResourceSqlStorage) Post(ctx context.Context, ctr *domain.Resource) (*domain.ResourceCriteria, error) {
	fmt.Println(ctr)

	if err := resource.db.Create(ctr).Error; err != nil {
		return nil, err
	}
	resourceResp := domain.ResourceCriteria{
		Name: &ctr.Name,
		URL:  &ctr.URL,
	}
	return &resourceResp, nil
}
