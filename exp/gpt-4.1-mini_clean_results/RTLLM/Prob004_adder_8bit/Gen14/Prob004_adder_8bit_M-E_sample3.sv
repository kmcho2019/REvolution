module adder_8bit (
    input  wire [7:0] a,    // 8-bit input operand A
    input  wire [7:0] b,    // 8-bit input operand B
    input  wire       cin,  // carry-in input
    output reg  [7:0] sum,  // 8-bit sum output
    output reg        cout  // carry-out output
);
    integer i;
    reg carry;

    always @(*) begin
        carry = cin;
        for (i = 0; i < 8; i = i + 1) begin
            sum[i] = a[i] ^ b[i] ^ carry;
            carry = (a[i] & b[i]) | (a[i] & carry) | (b[i] & carry);
        end
        cout = carry;
    end
endmodule