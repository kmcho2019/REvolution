module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

reg [31:0] cnt;

initial begin
    cnt = 0;
    clk = 0;
end

always #5 begin
    cnt <= cnt + 1;
    if (cnt == (PERIOD / 2)) begin
        cnt <= 0;
        clk <= ~clk;
    end
end

endmodule