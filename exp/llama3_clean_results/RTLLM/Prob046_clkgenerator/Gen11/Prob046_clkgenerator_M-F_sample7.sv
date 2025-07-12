module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

reg sysclk; // Internal high-frequency clock
reg [31:0] counter = 0;

// Initialize sysclk and clk
initial begin
    sysclk = 0;
    clk = 0;
end

// Toggle sysclk at a very high frequency (for simulation purposes, assume it's as fast as possible)
always #1 sysclk = ~sysclk; // This simulates a high-frequency internal clock

// Toggle clk based on the counter and desired period
always @(posedge sysclk) begin
    if (counter < (PERIOD / 2)) begin
        counter <= counter + 1;
    end else begin
        counter <= 0;
        clk <= ~clk;
    end
end

endmodule