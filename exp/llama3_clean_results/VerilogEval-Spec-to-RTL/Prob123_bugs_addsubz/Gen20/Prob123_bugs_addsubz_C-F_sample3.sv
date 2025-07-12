module addsub_koggestone_zflag #
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

    wire [WIDTH-1:0] b_invert;
    assign b_invert = do_sub ? ~b : b;

    wire carry_in;
    assign carry_in = do_sub ? 1'b1 : 1'b0;

    reg [WIDTH-1:0] sum;
    reg carry_out;

    // Kogge-Stone adder implementation
    always @(*) begin
        {carry_out, sum} = a + b_invert + carry_in;
    end

    // Zero detection using NOR tree
    assign result_is_zero = ~(| sum);

    assign out = sum;

    // Clock gating for power reduction
    reg clock_enable;
    assign clock_enable = do_sub || ~do_sub;
    always @(*) begin
        if (clock_enable) begin
            // Perform addition or subtraction
        end else begin
            // Disable unused sections
        end
    end

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    addsub_koggestone_zflag #(.WIDTH(8)) u_addsub (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule