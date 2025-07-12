module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

// Define the size of each sub-grid
localparam SUB_GRID_SIZE = 4;

// Calculate the number of sub-grids
localparam NUM_SUB_GRIDS = 16 / SUB_GRID_SIZE;

// Define the sub-grid module
module SubGrid(
    input clk,
    input load,
    input [SUB_GRID_SIZE*SUB_GRID_SIZE-1:0] data,
    output reg [SUB_GRID_SIZE*SUB_GRID_SIZE-1:0] q
);

reg [SUB_GRID_SIZE*SUB_GRID_SIZE-1:0] current_state;
reg [SUB_GRID_SIZE*SUB_GRID_SIZE-1:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        next_state <= current_state;
        for (int i = 0; i < SUB_GRID_SIZE*SUB_GRID_SIZE; i++) begin
            reg [2:0] count;
            count = 3'b0;
            for (int x = -1; x <= 1; x++) begin
                for (int y = -1; y <= 1; y++) begin
                    if ((x == 0) && (y == 0)) begin
                        // Skip the current cell
                    end else begin
                        reg [7:0] j, k;
                        j = (i / SUB_GRID_SIZE) + x;
                        k = (i % SUB_GRID_SIZE) + y;
                        if (current_state[((j % SUB_GRID_SIZE) * SUB_GRID_SIZE) + (k % SUB_GRID_SIZE)]) begin
                            count = count + 1'b1;
                        end
                    end
                end
            end
            if (count <= 1 || count >= 4) begin
                next_state[i] <= 1'b0;
            end else if (count == 3) begin
                next_state[i] <= 1'b1;
            end else begin
                next_state[i] <= current_state[i];
            end
        end
        current_state <= next_state;
    end
    q <= current_state;
end

endmodule

// Instantiate the sub-grid modules
SubGrid sub_grids [NUM_SUB_GRIDS-1:0] (
   .clk(clk),
   .load(load),
   .data(data[(NUM_SUB_GRIDS-1)*SUB_GRID_SIZE*SUB_GRID_SIZE-1:0]),
   .q(q[(NUM_SUB_GRIDS-1)*SUB_GRID_SIZE*SUB_GRID_SIZE-1:0])
);

// Wire the sub-grids together
for (genvar i = 0; i < NUM_SUB_GRIDS-1; i++) begin
    assign sub_grids[i].data[SUB_GRID_SIZE*SUB_GRID_SIZE-1:0] = data[(i+1)*SUB_GRID_SIZE*SUB_GRID_SIZE-1:i*SUB_GRID_SIZE*SUB_GRID_SIZE];
    assign q[(i+1)*SUB_GRID_SIZE*SUB_GRID_SIZE-1:i*SUB_GRID_SIZE*SUB_GRID_SIZE] = sub_grids[i].q;
end

endmodule