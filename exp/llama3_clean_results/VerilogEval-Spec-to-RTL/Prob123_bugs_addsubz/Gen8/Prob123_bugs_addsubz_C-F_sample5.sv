module twos_complement #
(
    parameter WIDTH = 8
)
(
    input [WIDTH-1:0] a,
    output [WIDTH-1:0] out
);

    assign out = ~a + 1;

endmodule

module alu #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output [WIDTH-1:0] out,
    output reg result_is_zero
);

    wire [WIDTH-1:0] b_selector;
    twos_complement #(.WIDTH(WIDTH)) u_twos_comp (
        .a(b),
        .out(b_selector)
    );
    assign b_selector = do_sub ? b_selector : b;

    assign out = a + b_selector;
    always @(*) begin
        if (~out)
            result_is_zero = 1;
        else
            result_is_zero = 0;
    end

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    alu #(.WIDTH(8)) u_alu (
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule