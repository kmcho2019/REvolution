module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg [31:0] counter = 0;
reg internal_clk = 0;

always #1 internal_clk = ~internal_clk; // Simulate a default clock tick at every time unit

always @(posedge internal_clk) begin
    counter <= counter + 1;
    
    if (counter == (PERIOD / 2)) begin
        clk <= ~clk;
        counter <= 0;
    end
end

endmodule