module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Define the size of the sub-grids
localparam SUBGRID_SIZE = 4;

// Define the number of sub-grids in each dimension
localparam NUM_SUBGRIDS_X = 16 / SUBGRID_SIZE;
localparam NUM_SUBGRIDS_Y = 16 / SUBGRID_SIZE;

// Define the total number of sub-grids
localparam NUM_SUBGRIDS = NUM_SUBGRIDS_X * NUM_SUBGRIDS_Y;

// Define the width of the sub-grid data
localparam SUBGRID_WIDTH = SUBGRID_SIZE * SUBGRID_SIZE;

// Define the width of the neighborhood data
localparam NEIGHBORHOOD_WIDTH = 3 * 3;

// Define the width of the pipeline stage data
localparam PIPELINE_STAGE_WIDTH = SUBGRID_WIDTH + NEIGHBORHOOD_WIDTH;

// Define the number of pipeline stages
localparam NUM_PIPELINE_STAGES = 3;

// Define the sub-grid processing units
reg [SUBGRID_WIDTH-1:0] subgrids [NUM_SUBGRIDS-1:0];

// Define the pipeline stages
reg [PIPELINE_STAGE_WIDTH-1:0] pipeline_stages [NUM_PIPELINE_STAGES-1:0];

// Define the neighborhood buffers
reg [NEIGHBORHOOD_WIDTH-1:0] neighborhood_buffers [NUM_SUBGRIDS-1:0];

// Load data into sub-grids
always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < NUM_SUBGRIDS; i++) begin
            subgrids[i] <= data[(i * SUBGRID_WIDTH) +: SUBGRID_WIDTH];
        end
    end
end

// Calculate neighborhood data for each sub-grid
always @(posedge clk) begin
    for (int i = 0; i < NUM_SUBGRIDS; i++) begin
        reg [NEIGHBORHOOD_WIDTH-1:0] neighborhood_data;
        // Calculate the neighborhood data for the current sub-grid
        for (int x = -1; x <= 1; x++) begin
            for (int y = -1; y <= 1; y++) begin
                int subgrid_x = (i % NUM_SUBGRIDS_X) + x;
                int subgrid_y = (i / NUM_SUBGRIDS_X) + y;
                int subgrid_index = (subgrid_y % NUM_SUBGRIDS_Y) * NUM_SUBGRIDS_X + (subgrid_x % NUM_SUBGRIDS_X);
                if (x == 0 && y == 0) begin
                    // Skip the current sub-grid
                end else begin
                    neighborhood_data += subgrids[subgrid_index];
                end
            end
        end
        neighborhood_buffers[i] <= neighborhood_data;
    end
end

// Pipeline the processing of each sub-grid
always @(posedge clk) begin
    for (int i = 0; i < NUM_PIPELINE_STAGES; i++) begin
        if (i == 0) begin
            // Load the sub-grid and neighborhood data into the pipeline
            pipeline_stages[i] <= {subgrids[0], neighborhood_buffers[0]};
        end else begin
            // Process the sub-grid and neighborhood data in the pipeline
            pipeline_stages[i] <= pipeline_stages[i-1];
        end
    end
end

// Update the sub-grids based on the pipeline output
always @(posedge clk) begin
    for (int i = 0; i < NUM_SUBGRIDS; i++) begin
        reg [SUBGRID_WIDTH-1:0] next_subgrid;
        // Calculate the next state of the sub-grid based on the pipeline output
        for (int j = 0; j < SUBGRID_SIZE; j++) begin
            for (int k = 0; k < SUBGRID_SIZE; k++) begin
                int index = (j * SUBGRID_SIZE) + k;
                int count = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        int subgrid_x = (i % NUM_SUBGRIDS_X) + x;
                        int subgrid_y = (i / NUM_SUBGRIDS_X) + y;
                        int subgrid_index = (subgrid_y % NUM_SUBGRIDS_Y) * NUM_SUBGRIDS_X + (subgrid_x % NUM_SUBGRIDS_X);
                        if (x == 0 && y == 0) begin
                            // Skip the current sub-grid
                        end else begin
                            count += subgrids[subgrid_index][index];
                        end
                    end
                end
                if (subgrids[i][index] == 1'b1) begin
                    if (count < 2 || count > 3) begin
                        next_subgrid[index] = 1'b0;
                    end
                end else if (count == 3) begin
                    next_subgrid[index] = 1'b1;
                end
            end
        end
        subgrids[i] <= next_subgrid;
    end
end

// Output the current state of the sub-grids
always @(posedge clk) begin
    reg [255:0] output;
    for (int i = 0; i < NUM_SUBGRIDS; i++) begin
        output[(i * SUBGRID_WIDTH) +: SUBGRID_WIDTH] <= subgrids[i];
    end
    q <= output;
end

endmodule