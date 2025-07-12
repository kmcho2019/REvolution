module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

initial begin
    clk = 1'b0; // Initialize clock to 0
end

always begin
    #((PERIOD / 2)) clk = 1'b1; // Set clock high
    #((PERIOD / 2)) clk = 1'b0; // Set clock low
end

endmodule