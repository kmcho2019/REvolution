module fixed_point_subtractor #(
    parameter Q = 8,  // Number of fractional bits
    parameter N = 16  // Total number of bits
)(
    input  [N-1:0] a,
    input  [N-1:0] b,
    output reg [N-1:0] c
);

// Internal wires for the carry-save adder
wire [N-1:0] sum;
wire [N-1:0] carry;

// Control signal to determine whether to perform direct subtraction or add the two's complement of b
reg perform_twos_complement;

// Perform subtraction based on the signs of a and b
always @(a or b) begin
    if (a[N-1] == b[N-1]) begin  // Same sign subtraction
        perform_twos_complement = 1'b0;
    end else begin  // Different sign subtraction
        perform_twos_complement = 1'b1;
    end
end

// Carry-save adder to perform the addition of a and the two's complement of b (if necessary)
assign sum = a + (perform_twos_complement ? (~b + 1) : b);
assign carry = (a[N-1] ^ (perform_twos_complement ? (~b[N-1] + 1) : b[N-1])) ? 0 : 1;

// Final adder to handle any carry-out from the CSA and produce the final result
always @(sum or carry) begin
    if (carry == 0) begin
        c <= sum;
    end else begin
        c <= sum + 1;
    end
end

endmodule