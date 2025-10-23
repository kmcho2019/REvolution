module adder_subtractor_lut #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    output result_is_zero
);

    reg [WIDTH-1:0] out_reg;
    assign out = out_reg;

    always @(*) begin
        if (do_sub) begin
            out_reg = a - b;
        end else begin
            out_reg = a + b;
        end
    end

    assign result_is_zero = (out == 0)? 1'b1 : 1'b0;

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output [7:0] out,
    output result_is_zero
);

    adder_subtractor_lut #(.WIDTH(8)) u_addsub (
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule