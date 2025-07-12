module ring_counter #(
    parameter WIDTH = 8,                // Configurable width
    parameter INIT_VAL = 8'b0000_0001  // Configurable initial value
) (
    input clk,
    input reset,
    output reg [WIDTH-1:0] out         // One-hot encoded output
);

// One-hot shift register with wrap-around
always @(posedge clk or posedge reset) begin
    if (reset) begin
        out <= INIT_VAL;  // Reset to configured initial state
    end
    else begin
        // Shift left with wrap-around (MSB goes to LSB position)
        out <= {out[WIDTH-2:0], out[WIDTH-1]};
    end
end

// Assertion to ensure one-hot property (for simulation)
// synthesis translate_off
always @(posedge clk) begin
    if (reset !== 1'b1 && $countones(out) != 1) begin
        $error("Ring counter violation: output is not one-hot encoded");
    end
end
// synthesis translate_on

endmodule