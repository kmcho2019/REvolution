module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

// Assuming we have a signal 'enable' that indicates when the counter should be active
// This signal can be used to gate the clock, reducing unnecessary switching activity
// For simplicity, we'll assume 'enable' is always high in this example, but in a real scenario,
// it would be controlled based on the system's requirements

wire gated_clk;
assign gated_clk = clk & enable; // Replace 'enable' with the actual control signal

always @(posedge gated_clk or posedge reset) begin
    if (reset) begin
        q <= 4'd0; // Synchronous reset to 0
    end else if (gated_clk) begin // Only increment if the gated clock is high
        q <= q + 1; // Increment counter by 1 on every positive edge of the gated clock
    end
end

endmodule