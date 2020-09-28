import { TestBed } from '@angular/core/testing';

import { TorenderService } from './torender.service';

describe('TorenderService', () => {
  let service: TorenderService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TorenderService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
