module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [3:0] phase_accumulator = 0;

always @(posedge phase_accumulator) begin
    phase_accumulator <= phase_accumulator + 1;
    if (phase_accumulator == (PERIOD / 2)) begin
        clk <= ~clk;
    end
end

initial begin
    clk = 0;
    phase_accumulator = 1;
end

endmodule