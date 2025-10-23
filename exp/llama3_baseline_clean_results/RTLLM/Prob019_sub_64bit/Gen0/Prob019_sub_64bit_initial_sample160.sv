module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform subtraction
assign result = A - B;

// Check for overflow
always @(*)
begin
    if ((A[63] == 0 && B[63] == 1 && result[63] == 1) || (A[63] == 1 && B[63] == 0 && result[63] == 0)) 
    begin
        overflow = 1'b1; // Set overflow flag if overflow condition is detected
    end
    else
    begin
        overflow = 1'b0; // Clear overflow flag if no overflow condition is detected
    end
end

endmodule