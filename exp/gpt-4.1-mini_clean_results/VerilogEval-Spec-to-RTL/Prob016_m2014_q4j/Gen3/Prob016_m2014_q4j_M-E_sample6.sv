module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output reg [4:0] sum
);
    integer i;
    reg [4:0] carry;

    always @(*) begin
        carry[0] = 1'b0; // initial carry-in
        for (i = 0; i < 4; i = i + 1) begin
            sum[i] = x[i] ^ y[i] ^ carry[i];
            carry[i+1] = (x[i] & y[i]) | (x[i] & carry[i]) | (y[i] & carry[i]);
        end
        sum[4] = carry[4]; // final carry-out as overflow bit
    end
endmodule