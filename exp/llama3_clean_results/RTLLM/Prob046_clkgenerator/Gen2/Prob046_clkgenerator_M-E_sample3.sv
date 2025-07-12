module clkgenerator(
    output reg clk
);

parameter PERIOD = 10;
parameter PHASES = 2; // number of phases within the period

reg [31:0] phase_cnt;

always @(posedge clk or negedge clk) begin
    if (phase_cnt == (PERIOD / PHASES) - 1) begin
        phase_cnt <= 0;
        clk <= ~clk;
    end else begin
        phase_cnt <= phase_cnt + 1;
    end
end

initial begin
    phase_cnt = 0;
    clk = 0;
end

endmodule