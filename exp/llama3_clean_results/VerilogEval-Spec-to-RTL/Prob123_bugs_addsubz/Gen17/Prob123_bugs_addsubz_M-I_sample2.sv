module addsub_cla_zflag #
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

    // Invert b if subtraction is required
    wire [WIDTH-1:0] b_invert;
    assign b_invert = do_sub ? ~b : b;

    // Determine carry-in based on operation
    wire carry_in;
    assign carry_in = do_sub ? 1'b1 : 1'b0;

    // Carry-lookahead adder implementation
    reg [WIDTH-1:0] sum;
    reg carry_out;

    // Explicitly implement adder logic for better control
    always @(*) begin
        {carry_out, sum} = a + {WIDTH{carry_in}} & b_invert + {WIDTH{1'b0}} & carry_in;
    end

    // Simplified zero detection logic
    assign result_is_zero = ~( | sum);

    assign out = sum;

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    addsub_cla_zflag #(.WIDTH(8)) u_addsub (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule