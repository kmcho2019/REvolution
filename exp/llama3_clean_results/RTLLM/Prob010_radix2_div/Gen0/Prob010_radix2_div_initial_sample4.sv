// Testbench
module tb_radix2_div();
reg clk;
reg rst;
reg sign;
reg [7:0] dividend;
reg [7:0] divisor;
reg opn_valid;
wire res_valid;
wire [15:0] result;

radix2_div uut(
    .clk(clk),
    .rst(rst),
    .sign(sign),
    .dividend(dividend),
    .divisor(divisor),
    .opn_valid(opn_valid),
    .res_valid(res_valid),
    .result(result)
);

initial begin
    clk = 0;
    forever begin
        #5;
        clk = ~clk;
    end
end

initial begin
    rst = 1;
    sign = 0;
    dividend = 8'd10;
    divisor = 8'd2;
    opn_valid = 0;
    #10;
    rst = 0;
    opn_valid = 1;
    #20;
    opn_valid = 0;
    #20;
    $finish;
end

endmodule