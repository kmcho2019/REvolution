module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output reg [4:0] sum
);
    integer i;
    reg carry;

    always @(*) begin
        carry = 0;
        for (i = 0; i < 4; i = i + 1) begin
            // sum bit is XOR of x, y and carry
            sum[i] = x[i] ^ y[i] ^ carry;
            // carry out for next bit
            carry = (x[i] & y[i]) | (x[i] & carry) | (y[i] & carry);
        end
        // final carry as MSB of sum
        sum[4] = carry;
    end
endmodule