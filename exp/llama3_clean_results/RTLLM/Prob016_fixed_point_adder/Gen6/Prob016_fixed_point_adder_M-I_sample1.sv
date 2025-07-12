module fixed_point_adder #(
    parameter Q = 16, // Number of fractional bits (precision)
    parameter N = 32 // Total number of bits, including integer and fractional parts
) (
    input [N-1:0] a, // First N-bit fixed-point input operand
    input [N-1:0] b, // Second N-bit fixed-point input operand
    output reg [N-1:0] c // N-bit output representing the result of the fixed-point addition
);

// Stage 1 & 2: Sign Determination, Absolute Value Calculation, and Arithmetic Operation
reg [N:0] temp_result; // Temporary result of arithmetic operation

always @(*) begin
    temp_result = (a[N-1] == b[N-1])? 
        ((a[N-1] == 1'b0)? (a + b) : (-(~a + 1'b1) - (~b + 1'b1))) : 
        ((a >= b)? (a - b) : (b - a));
end

// Stage 3: Overflow Handling and Result Formation
always @(*) begin
    if (temp_result[N] == 1'b1) begin // Overflow
        c = (temp_result[N-1] == 1'b1)? {1'b1, {N-1{1'b0}}} : {1'b0, {N-1{1'b0}}};
    end else begin
        c = temp_result[N-1:0];
    end
end

endmodule