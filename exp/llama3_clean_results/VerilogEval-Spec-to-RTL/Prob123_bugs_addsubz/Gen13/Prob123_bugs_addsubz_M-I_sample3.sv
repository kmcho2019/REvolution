module addsub_zflag #
(
    parameter WIDTH = 8
)
(
    input do_sub,
    input [WIDTH-1:0] a,
    input [WIDTH-1:0] b,
    output reg [WIDTH-1:0] out,
    output reg result_is_zero
);

    // Use a ripple-carry adder for efficient addition and subtraction
    wire [WIDTH-1:0] b_mux;
    assign b_mux = do_sub? (~b + 1) : b;

    wire [WIDTH-1:0] add_result;
    assign add_result = a + b_mux;

    // Minimize logic gates in zero flag generation
    assign result_is_zero = ~(|add_result);

    assign out = add_result;

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    addsub_zflag #(.WIDTH(8)) u_addsub (
       .do_sub(do_sub),
       .a(a),
       .b(b),
       .out(out),
       .result_is_zero(result_is_zero)
    );

endmodule