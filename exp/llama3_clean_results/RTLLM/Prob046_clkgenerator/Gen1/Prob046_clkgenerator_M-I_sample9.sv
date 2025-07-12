module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

always begin
    #((PERIOD / 2)) clk <= 1'b1; // Set clock high for half of the period
    #((PERIOD / 2)) clk <= 1'b0; // Set clock low for half of the period
end

endmodule