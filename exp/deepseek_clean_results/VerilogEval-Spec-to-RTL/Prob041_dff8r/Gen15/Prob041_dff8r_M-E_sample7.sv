module SmartDFFArray (
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q,
    // Additional control signals
    input mode,       // 0 = parallel load, 1 = shift right
    input shift_in,    // Serial input for shift mode
    input valid,       // Data valid strobe
    input clk_en       // Clock enable
);

wire actual_clk_en = clk_en & valid;  // Combined enable condition

always @(posedge clk) begin
    if (reset) begin
        q <= 8'b0;  // Synchronous reset
    end else if (actual_clk_en) begin
        if (mode) begin
            // Shift mode: right shift with serial input
            q <= {shift_in, q[7:1]};
        end else begin
            // Parallel load mode
            q <= d;
        end
    end
    // Else hold current value
end

endmodule

module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

// Instantiate with default configuration:
// - Always in parallel load mode
// - Always enabled
// - Shift input tied to 0 (unused)
SmartDFFArray dff_array (
    .clk(clk),
    .reset(reset),
    .d(d),
    .q(q),
    .mode(1'b0),
    .shift_in(1'b0),
    .valid(1'b1),
    .clk_en(1'b1)
);

endmodule