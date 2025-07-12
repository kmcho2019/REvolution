module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;

reg [31:0] cnt;

always @(posedge cnt) begin
    if (cnt == (PERIOD / 2) - 1) begin
        cnt <= 0;
        clk <= ~clk;
    end else begin
        cnt <= cnt + 1;
    end
end

initial begin
    cnt = 0;
    clk = 0;
end

// add a reference clock for simulation
reg ref_clk;
initial begin
    ref_clk = 0;
    forever #5 ref_clk = ~ref_clk;
end

always @(posedge ref_clk) begin
    cnt <= cnt + 1;
end

endmodule