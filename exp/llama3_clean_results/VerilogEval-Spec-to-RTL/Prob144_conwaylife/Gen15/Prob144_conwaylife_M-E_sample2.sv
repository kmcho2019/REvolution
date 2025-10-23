module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Define the size of the sub-grids
localparam SUB_GRID_SIZE = 4;

// Define the size of the kernel
localparam KERNEL_SIZE = 3;

// Define the number of sub-grids
localparam NUM_SUB_GRIDS = 16;

// Define the memory to store the sub-grids
reg [SUB_GRID_SIZE*SUB_GRID_SIZE-1:0] sub_grids [NUM_SUB_GRIDS-1:0];

// Define the memory to store the results
reg [SUB_GRID_SIZE*SUB_GRID_SIZE-1:0] results [NUM_SUB_GRIDS-1:0];

// Define the convolutional kernel
reg [KERNEL_SIZE*KERNEL_SIZE-1:0] kernel;

// Initialize the kernel
initial begin
    kernel[0] = 1; kernel[1] = 1; kernel[2] = 1;
    kernel[3] = 1; kernel[4] = 0; kernel[5] = 1;
    kernel[6] = 1; kernel[7] = 1; kernel[8] = 1;
end

// Divide the 16x16 grid into sub-grids
always @(posedge clk) begin
    if (load) begin
        for (int i = 0; i < NUM_SUB_GRIDS; i++) begin
            for (int j = 0; j < SUB_GRID_SIZE; j++) begin
                for (int k = 0; k < SUB_GRID_SIZE; k++) begin
                    sub_grids[i][j*SUB_GRID_SIZE+k] <= data[(i/SUB_GRID_SIZE)*SUB_GRID_SIZE*SUB_GRID_SIZE + j*SUB_GRID_SIZE+k];
                end
            end
        end
    end
end

// Convolve the kernel with each sub-grid
always @(posedge clk) begin
    for (int i = 0; i < NUM_SUB_GRIDS; i++) begin
        for (int j = 0; j < SUB_GRID_SIZE; j++) begin
            for (int k = 0; k < SUB_GRID_SIZE; k++) begin
                reg [KERNEL_SIZE*KERNEL_SIZE-1:0] temp;
                for (int x = 0; x < KERNEL_SIZE; x++) begin
                    for (int y = 0; y < KERNEL_SIZE; y++) begin
                        temp[x*KERNEL_SIZE+y] <= sub_grids[i][(j+x-1)%SUB_GRID_SIZE*SUB_GRID_SIZE+(k+y-1)%SUB_GRID_SIZE];
                    end
                end
                reg [SUB_GRID_SIZE*SUB_GRID_SIZE-1:0] result;
                for (int x = 0; x < SUB_GRID_SIZE; x++) begin
                    for (int y = 0; y < SUB_GRID_SIZE; y++) begin
                        result[x*SUB_GRID_SIZE+y] <= (temp & kernel);
                    end
                end
                results[i] <= result;
            end
        end
    end
end

// Generate the next state
always @(posedge clk) begin
    for (int i = 0; i < NUM_SUB_GRIDS; i++) begin
        for (int j = 0; j < SUB_GRID_SIZE; j++) begin
            for (int k = 0; k < SUB_GRID_SIZE; k++) begin
                if (results[i][j*SUB_GRID_SIZE+k] == 3 || (results[i][j*SUB_GRID_SIZE+k] == 2 && sub_grids[i][j*SUB_GRID_SIZE+k])) begin
                    sub_grids[i][j*SUB_GRID_SIZE+k] <= 1;
                end else begin
                    sub_grids[i][j*SUB_GRID_SIZE+k] <= 0;
                end
            end
        end
    end
end

// Combine the results
always @(posedge clk) begin
    for (int i = 0; i < NUM_SUB_GRIDS; i++) begin
        for (int j = 0; j < SUB_GRID_SIZE; j++) begin
            for (int k = 0; k < SUB_GRID_SIZE; k++) begin
                q[(i/SUB_GRID_SIZE)*SUB_GRID_SIZE*SUB_GRID_SIZE + j*SUB_GRID_SIZE+k] <= sub_grids[i][j*SUB_GRID_SIZE+k];
            end
        end
    end
end

endmodule