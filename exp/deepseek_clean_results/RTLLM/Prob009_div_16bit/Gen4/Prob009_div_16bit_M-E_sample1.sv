module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

// Segment the dividend into 4 nibbles
wire [3:0] nibble3 = A[15:12];
wire [3:0] nibble2 = A[11:8];
wire [3:0] nibble1 = A[7:4];
wire [3:0] nibble0 = A[3:0];

// Compute partial quotients and remainders for each nibble
wire [3:0] q3, q2, q1, q0;
wire [7:0] r3, r2, r1, r0;

nibble_div nd3 (.dividend({4'b0, nibble3}), .divisor(B), .quotient(q3), .remainder(r3));
nibble_div nd2 (.dividend({r3[3:0], nibble2}), .divisor(B), .quotient(q2), .remainder(r2));
nibble_div nd1 (.dividend({r2[3:0], nibble1}), .divisor(B), .quotient(q1), .remainder(r1));
nibble_div nd0 (.dividend({r1[3:0], nibble0}), .divisor(B), .quotient(q0), .remainder(r0));

// Combine partial quotients
assign result = {q3, q2, q1, q0};
assign odd = {8'b0, r0};  // Final remainder is in r0

endmodule

// Helper module for 4-bit division
module nibble_div (
    input [7:0] dividend,  // 4-bit dividend + 4-bit remainder from previous
    input [7:0] divisor,
    output reg [3:0] quotient,
    output reg [7:0] remainder
);

always @(*) begin
    // Initialize
    remainder = dividend;
    quotient = 4'b0;
    
    // Unrolled 4-bit division
    if (remainder >= {divisor, 4'b0}) begin
        remainder = remainder - {divisor, 4'b0};
        quotient[3] = 1'b1;
    end
    if (remainder >= {1'b0, divisor, 3'b0}) begin
        remainder = remainder - {1'b0, divisor, 3'b0};
        quotient[2] = 1'b1;
    end
    if (remainder >= {2'b0, divisor, 2'b0}) begin
        remainder = remainder - {2'b0, divisor, 2'b0};
        quotient[1] = 1'b1;
    end
    if (remainder >= {3'b0, divisor, 1'b0}) begin
        remainder = remainder - {3'b0, divisor, 1'b0};
        quotient[0] = 1'b1;
    end
end

endmodule