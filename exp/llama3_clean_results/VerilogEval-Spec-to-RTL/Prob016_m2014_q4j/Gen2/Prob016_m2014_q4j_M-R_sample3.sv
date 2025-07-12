module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);

reg [4:0] sum_reg;
reg [3:0] carry;

always @(*) begin
    carry[0] = 0;
    sum_reg[0] = x[0] ^ y[0] ^ carry[0];
    carry[1] = (x[0] & y[0]) | (x[0] & carry[0]) | (y[0] & carry[0]);
    
    sum_reg[1] = x[1] ^ y[1] ^ carry[1];
    carry[2] = (x[1] & y[1]) | (x[1] & carry[1]) | (y[1] & carry[1]);
    
    sum_reg[2] = x[2] ^ y[2] ^ carry[2];
    carry[3] = (x[2] & y[2]) | (x[2] & carry[2]) | (y[2] & carry[2]);
    
    sum_reg[3] = x[3] ^ y[3] ^ carry[3];
    sum_reg[4] = (x[3] & y[3]) | (x[3] & carry[3]) | (y[3] & carry[3]);
end

assign sum = sum_reg;

endmodule