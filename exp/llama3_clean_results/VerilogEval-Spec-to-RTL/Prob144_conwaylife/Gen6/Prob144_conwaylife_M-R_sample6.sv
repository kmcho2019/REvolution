module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;

// Combinational logic block to compute alive neighbors count
wire [255:0] alive_neighbors;
genvar i, j;
generate
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            integer index = i * 16 + j;
            wire [3:0] alive_neighbors_count;
            assign alive_neighbors_count = (
                grid[((i-1+16)%16)*16 + (j-1+16)%16] +
                grid[((i-1+16)%16)*16 + j] +
                grid[((i-1+16)%16)*16 + (j+1)%16] +
                grid[i*16 + (j-1+16)%16] +
                grid[i*16 + (j+1)%16] +
                grid[((i+1)%16)*16 + (j-1+16)%16] +
                grid[((i+1)%16)*16 + j] +
                grid[((i+1)%16)*16 + (j+1)%16]
            );
            assign alive_neighbors[index] = alive_neighbors_count;
        end
    end
endgenerate

// Sequential logic block to update grid state
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (integer i = 0; i < 256; i++) begin
            case (alive_neighbors[i])
                0, 1: q[i] <= 0;
                2: q[i] <= grid[i];
                3: q[i] <= 1;
                default: q[i] <= 0;
            endcase
            grid[i] <= q[i];
        end
    end
end

endmodule