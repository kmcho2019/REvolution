module TopModule(
    input clk,
    input d,
    output reg q
);

// Initialize q to a default value for a defined state at startup
initial q = 1'b0;

// Create an internal signal for the inverted clock
wire clk_inv;

// Invert the clock signal
assign clk_inv = ~clk;

// Use a MUX to select between the current state (q) and the new data (d)
always @(*) begin
    if (clk_inv) begin
        q = q; // Hold the current state when clock is low
    end else begin
        q = d; // Update the state with new data when clock rises
    end
end

endmodule