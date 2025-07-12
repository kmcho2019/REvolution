module addsub_ppa_zflag #
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
    assign b_invert = do_sub ? ~b : b;

    // Calculate carry-in for subtraction
    wire carry_in;
    assign carry_in = do_sub ? 1'b1 : 1'b0;

    reg [WIDTH-1:0] sum;

    // Parallel prefix adder implementation
    wire [WIDTH-1:0] carry;
    assign carry[0] = carry_in;
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin: gen_carry
            if (i == 0) begin
                assign carry[i] = carry_in;
            end else begin
                assign carry[i] = (a[i] & b_invert[i]) | (a[i] & carry[i-1]) | (b_invert[i] & carry[i-1]);
            end
        end
    endgenerate

    always @(*) begin
        sum = a + b_invert + carry_in;
    end

    // Zero detection using OR reduction tree
    assign result_is_zero = ~(| sum);

    assign out = sum;

endmodule

module TopModule (
    input do_sub,
    input [7:0] a,
    input [7:0] b,
    output reg [7:0] out,
    output reg result_is_zero
);

    addsub_ppa_zflag #(.WIDTH(8)) u_addsub (
        .do_sub(do_sub),
        .a(a),
        .b(b),
        .out(out),
        .result_is_zero(result_is_zero)
    );

endmodule