module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

integer half_period;

initial begin
    half_period = PERIOD / 2;
    clk = 1'b0; // Initialize clock to 0
end

always @(clk) begin
    if (clk == 1'b0) begin
        #half_period clk <= 1'b1; // Set clock high for half of the period
    end else begin
        #half_period clk <= 1'b0; // Set clock low for half of the period
    end
end

endmodule