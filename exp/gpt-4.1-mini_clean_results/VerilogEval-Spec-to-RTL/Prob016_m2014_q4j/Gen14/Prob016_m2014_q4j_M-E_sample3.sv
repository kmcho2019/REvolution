module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output reg [4:0] sum
);
    integer i;
    reg carry;

    always @(*) begin
        carry = 0;
        for (i = 0; i < 4; i = i + 1) begin
            {carry, sum[i]} = x[i] + y[i] + carry;
        end
        sum[4] = carry; // final carry out as overflow bit
    end
endmodule