module clkgenerator(
    output reg clk,
    input  wire reset
);

parameter PERIOD = 10;

reg [31:0] cnt;

always @(posedge reset or posedge clk) begin
    if (reset) begin
        cnt <= 0;
        clk <= 0;
    end else if (cnt == (PERIOD / 2)) begin
        cnt <= 0;
        clk <= ~clk;
    end else begin
        cnt <= cnt + 1;
    end
end

endmodule