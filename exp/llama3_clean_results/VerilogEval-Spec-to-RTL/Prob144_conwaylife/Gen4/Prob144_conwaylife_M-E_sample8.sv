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

reg [1:0] state;

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

// Row module
module row_module(
    input clk,
    input [15:0] data,
    input load,
    output reg [15:0] q
);

genvar i;
generate
    for (i = 0; i < 16; i++) begin
        cell_module cell(
           .clk(clk),
           .neighbors({q[(i+1)%16], q[(i-1+16)%16], q[i], data[(i+1)%16], data[(i-1+16)%16]}),
           .load(load),
           .data(data[i]),
           .q(q[i])
        );
    end
endgenerate

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
           .data(data[i*16 +: 16]),
           .load(load),
           .q(q[i*16 +: 16])
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