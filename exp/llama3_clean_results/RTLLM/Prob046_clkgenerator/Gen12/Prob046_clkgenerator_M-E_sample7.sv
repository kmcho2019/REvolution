module clkgenerator #(
    parameter PERIOD = 10
)(
    output reg clk
);

// Default clock frequency for simulation purposes
parameter DEFAULT_CLK_FREQ = 100;

// Calculate the half period in terms of clock cycles
localparam HALF_PERIOD = (PERIOD * DEFAULT_CLK_FREQ) / 2;

reg [31:0] counter; // Counter variable to track clock cycles
reg clk_reg; // Register to hold the clock signal

initial begin
    clk_reg = 0; // Initialize clock signal to 0
    counter = 0; // Initialize counter to 0
end

always @(posedge $root.clk) begin // Assuming $root.clk is the default clock signal
    if (counter == HALF_PERIOD - 1) begin
        clk_reg <= ~clk_reg; // Toggle clock signal
        counter <= 0; // Reset counter
    end else begin
        counter <= counter + 1; // Increment counter
    end
end

assign clk = clk_reg; // Assign the clock register to the output

endmodule