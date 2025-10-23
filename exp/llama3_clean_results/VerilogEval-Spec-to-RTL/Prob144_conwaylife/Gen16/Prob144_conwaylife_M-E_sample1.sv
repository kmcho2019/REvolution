module Cell(
    input clk,
    input load,
    input data,
    input [7:0] neighbors,
    output reg q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        case (neighbors)
            8'b00000000, 8'b00000001: q <= 0;
            8'b00000010: q <= q;
            8'b00000100: q <= 1;
            default: q <= 0;
        endcase
    end
end

endmodule

module Row(
    input clk,
    input load,
    input [15:0] data,
    input [15:0] left,
    input [15:0] right,
    output reg [15:0] q
);

genvar i;
generate
    for (i = 0; i < 16; i++) begin
        wire [7:0] neighbors;
        assign neighbors[0] = left[i];
        assign neighbors[1] = (i == 0)? right[15] : data[i - 1];
        assign neighbors[2] = data[i];
        assign neighbors[3] = (i == 15)? left[0] : data[i + 1];
        assign neighbors[4] = right[i];
        assign neighbors[5] = (i == 0)? data[15] : data[i - 1];
        assign neighbors[6] = (i == 15)? data[0] : data[i + 1];
        assign neighbors[7] = (i == 0)? right[15] : right[i - 1];

        Cell cell(
           .clk(clk),
           .load(load),
           .data(data[i]),
           .neighbors(neighbors),
           .q(q[i])
        );
    end
endgenerate

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

genvar i;
generate
    for (i = 0; i < 16; i++) begin
        wire [15:0] left;
        wire [15:0] right;
        assign left = (i == 0)? q[15*16 +: 16] : q[(i - 1)*16 +: 16];
        assign right = (i == 15)? q[0 +: 16] : q[(i + 1)*16 +: 16];

        Row row(
           .clk(clk),
           .load(load),
           .data(data[i*16 +: 16]),
           .left(left),
           .right(right),
           .q(q[i*16 +: 16])
        );
    end
endgenerate

endmodule