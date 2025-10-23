module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk = 1'b0
);

reg [$clog2(PERIOD) - 1:0] phase_accumulator = 0;

always @(posedge clk or negedge clk) begin
    phase_accumulator <= phase_accumulator + 1;
    if (phase_accumulator == PERIOD - 1) begin
        clk <= ~clk;
        phase_accumulator <= 0;
    end
end

initial begin
    clk = 1'b0;
    #1;
    clk = 1'b1;
end

endmodule