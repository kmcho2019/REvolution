module adder_bcd(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

// Declare internal signals
reg [4:0] sum_internal; // To hold the result of binary addition
reg [3:0] corrected_sum; // To hold the corrected BCD sum
reg Cout_internal; // To hold the carry-out status

// Perform binary addition
always @(A, B, Cin) begin
    sum_internal = A + B + Cin;
end

// Apply BCD correction and generate carry-out
always @(sum_internal) begin
    if (sum_internal > 9) begin
        corrected_sum = sum_internal + 6;
        Cout_internal = 1'b1;
    end else begin
        corrected_sum = sum_internal[3:0]; // Only consider the lower 4 bits
        Cout_internal = 1'b0;
    end
end

// Assign outputs
assign Sum = corrected_sum;
assign Cout = Cout_internal;

endmodule