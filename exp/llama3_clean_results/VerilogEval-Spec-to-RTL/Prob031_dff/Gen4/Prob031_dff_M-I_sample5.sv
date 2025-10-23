module TopModule(
    input clk,
    input d,
    input reset, // Added reset input
    output reg q
);

// Initialize q to a default value for a defined state at startup
initial q = 1'b0;

// Reg to hold the previous value of d for clock gating
reg prev_d;
initial prev_d = 1'b0;

// Clock gating logic
reg clk_enable;
always @(posedge clk) begin
    prev_d <= d;
end

assign clk_enable = (d !== prev_d) || reset;

// Use an always block with a sensitivity list to the positive edge of the clock
always @(posedge clk) begin
    if (clk_enable) begin
        // Update q with the value of d using non-blocking assignment
        if (reset) begin
            q <= 1'b0; // Reset q to 0
        end else begin
            q <= d;
        end
    end
end

endmodule