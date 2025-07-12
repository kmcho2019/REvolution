module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

always begin
    #((PERIOD / 2)) clk = 1'b1; // High phase
    #((PERIOD / 2)) clk = 1'b0; // Low phase
end

initial begin
    clk = 1'b0;
end

endmodule