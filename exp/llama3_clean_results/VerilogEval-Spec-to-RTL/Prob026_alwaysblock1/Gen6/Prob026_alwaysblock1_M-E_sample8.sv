module TopModule #(
    parameter WIDTH = 1
)(
    input  [WIDTH-1:0] a,
    input  [WIDTH-1:0] b,
    output [WIDTH-1:0] out_assign,
    output [WIDTH-1:0] out_alwaysblock
);

assign out_assign = a & b;

always @(*) begin
    out_alwaysblock = a & b;
end

endmodule

module testbench;
    reg [0:0] a, b;
    wire [0:0] out_assign, out_alwaysblock;

    TopModule u_top_module(
        .a(a),
        .b(b),
        .out_assign(out_assign),
        .out_alwaysblock(out_alwaysblock)
    );

    initial begin
        a = 1'b0; b = 1'b0;
        #10 a = 1'b1; b = 1'b0;
        #10 a = 1'b0; b = 1'b1;
        #10 a = 1'b1; b = 1'b1;
    end

endmodule