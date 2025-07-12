module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

// Cell module
module cell_module(
    input clk,
    input [7:0] neighbors,
    input load,
    input data,
    output reg q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (neighbors)
            0, 1: q <= 0;
            2: q <= q;
            3: q <= 1;
            default: q <= 0;
        endcase
    end
end

endmodule

// Neighbor calculation module
module neighbor_module(
    input [255:0] q,
    input [3:0] row,
    input [3:0] col,
    output reg [7:0] neighbors
);

reg [7:0] n;

always @(*) begin
    n = 0;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) continue;
            int r = (row + i + 16) % 16;
            int c = (col + j + 16) % 16;
            n += q[r*16 + c];
        end
    end
    neighbors <= n;
end

endmodule

// Row module
module row_module(
    input clk,
    input [255:0] q,
    input load,
    input [15:0] data,
    output reg [15:0] next_q
);

genvar i;
generate
    for (i = 0; i < 16; i++) begin
        neighbor_module neighbor(
            .q(q),
            .row(i/16),
            .col(i%16),
            .neighbors(neighbors[i])
        );
        cell_module cell(
            .clk(clk),
            .neighbors(neighbors[i]),
            .load(load),
            .data(data[i]),
            .q(next_q[i])
        );
    end
endgenerate

reg [7:0] neighbors[15:0];

endmodule

// Grid module
module grid_module(
    input clk,
    input [255:0] data,
    input load,
    output reg [255:0] q
);

genvar i;
generate
    for (i = 0; i < 16; i++) begin
        row_module row(
            .clk(clk),
            .q(q),
            .load(load),
            .data(data[i*16 +: 16]),
            .next_q(q[i*16 +: 16])
        );
    end
endgenerate

endmodule

grid_module grid(
    .clk(clk),
    .data(data),
    .load(load),
    .q(q)
);

endmodule