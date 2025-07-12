// AliveNeighbors module
module AliveNeighbors(
    input [255:0] q,
    input [7:0] row,
    input [3:0] col,
    output reg [2:0] alive_neighbors
);

    always @(*) begin
        alive_neighbors = 0;
        for (reg [1:0] x = 0; x < 3; x = x + 1) begin
            for (reg [1:0] y = 0; y < 3; y = y + 1) begin
                if (x!= 1 || y!= 1) begin
                    reg [3:0] x_index = (row + x - 1 + 16) % 16;
                    reg [3:0] y_index = (col + y - 1 + 16) % 16;
                    reg [7:0] neighbor_index = (x_index * 16) + y_index;
                    if (q[neighbor_index]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
        end
    end

endmodule

// TopModule
module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

// Instantiate AliveNeighbors module for each cell
genvar i;
generate
    for (i = 0; i < 256; i = i + 1) begin
        reg [7:0] row = i / 16;
        reg [3:0] col = i % 16;
        wire [2:0] alive_neighbors;
        AliveNeighbors alive_neighbors_module(
            .q(q),
            .row(row),
            .col(col),
            .alive_neighbors(alive_neighbors)
        );

        // Update next state based on alive neighbors
        assign next_q[i] = (alive_neighbors == 3 || (alive_neighbors == 2 && q[i]));
    end
endgenerate

// Update q on clock edge
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule