module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [2:0] ring_osc = 3'b111;
reg delay_en = 1'b0;

always @(ring_osc) begin
    #1;
    ring_osc <= ~ring_osc;
    if (ring_osc == 3'b000) begin
        delay_en <= ~delay_en;
    end
end

always @(delay_en) begin
    #((PERIOD / 2));
    clk <= ~clk;
end

endmodule