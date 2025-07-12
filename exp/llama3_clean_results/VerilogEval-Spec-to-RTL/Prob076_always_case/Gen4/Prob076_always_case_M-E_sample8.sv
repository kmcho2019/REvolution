module TopModule(
    input  [2:0] sel,
    input  [3:0] data0,
    input  [3:0] data1,
    input  [3:0] data2,
    input  [3:0] data3,
    input  [3:0] data4,
    input  [3:0] data5,
    output reg [3:0] out
);

// 2-to-1 multiplexer module
module mux2to1(
    input  [3:0] data0,
    input  [3:0] data1,
    input  sel,
    output reg [3:0] out
);
    always @(*) begin
        if (sel == 1'b0) begin
            out = data0;
        end else begin
            out = data1;
        end
    end
endmodule

// Instantiate 2-to-1 multiplexers to form a 6-to-1 multiplexer
reg [3:0] out0, out1, out2;

mux2to1 u0(
    .data0(data0),
    .data1(data1),
    .sel(sel[0]),
    .out(out0)
);

mux2to1 u1(
    .data0(data2),
    .data1(data3),
    .sel(sel[0]),
    .out(out1)
);

mux2to1 u2(
    .data0(data4),
    .data1(data5),
    .sel(sel[0]),
    .out(out2)
);

mux2to1 u3(
    .data0(out0),
    .data1(out1),
    .sel(sel[1]),
    .out(out[3:0])
);

mux2to1 u4(
    .data0(out[3:0]),
    .data1(out2),
    .sel(sel[2]),
    .out(out[3:0])
);

endmodule