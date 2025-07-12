module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    wire carry;
    assign carry = cin; // Initialize carry chain

    // Implement 8 full adders directly
    integer i;
    always @(*) begin
        for (i = 0; i < 8; i = i + 1) begin
            sum[i] = a[i] ^ b[i] ^ carry;
            carry = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry);
        end
    end

    assign cout = carry; // Final carry becomes output

endmodule