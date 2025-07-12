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

    // Invert b when subtraction is required
    wire [WIDTH-1:0] b_invert;
    assign b_invert = do_sub? ~b : b;

    // Calculate carry-in for subtraction
    wire carry_in;
    assign carry_in = do_sub;

    reg [WIDTH-1:0] sum;

    // Kogge-Stone adder implementation
    wire [WIDTH-1:0] carry;
    assign carry[0] = carry_in;
    genvar i;
    generate
        for (i = 1; i < WIDTH; i++) begin: gen_carry
            assign carry[i] = (a[i] & b_invert[i]) | (a[i] & carry[i-1]) | (b_invert[i] & carry[i-1]);
        end
    endgenerate

    always @(*) begin
        sum = a + b_invert + carry_in;
    end

    // Zero detection using tree of AND-OR gates
    assign result_is_zero = ~(sum[0] | sum[1] | (sum[2] | sum[3]) | ((sum[4] | sum[5]) | (sum[6] | sum[7])));

    assign out = sum;

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