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

    // Define a 1-bit full adder
    wire [WIDTH-1:0] sum;
    wire [WIDTH-1:0] carry;

    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            // Conditional statement to select between original value of b and its two's complement
            wire b_mux = do_sub ? ~b[i] : b[i];

            // 1-bit full adder
            assign sum[i] = a[i] ^ b_mux ^ carry[i];
            assign carry[i] = (a[i] & b_mux) | (a[i] & carry[i]) | (b_mux & carry[i]);

            // Generate carry for next bit position
            if (i == 0) begin
                assign carry[i] = do_sub ? 1'b1 : 1'b0;
            end else begin
                assign carry[i] = carry[i-1];
            end
        end
    endgenerate

    // Generate zero flag
    assign result_is_zero = ~(|sum);

    assign out = sum;

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