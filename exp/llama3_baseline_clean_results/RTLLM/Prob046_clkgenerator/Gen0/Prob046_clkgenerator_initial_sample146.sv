module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;

initial clk = 0;

always @(clk) begin
    counter <= counter + 1;
    if (counter == (PERIOD / 2)) begin
        clk <= ~clk;
        counter <= 0;
    end
end

endmodule