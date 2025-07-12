// Module: counter_12_refactored
// Description: A refactored version of the 4-bit counter that counts from 0 to 11 and is controlled by the input signal valid_count.
//              The counter resets to 0 when the reset signal (rst_n) is active low.

module counter_12_refactored (
    input  logic        rst_n,  // Reset signal (active low)
    input  logic        clk,    // Clock signal
    input  logic        valid_count,  // Signal to enable counting
    output logic [3:0]  out     // 4-bit output representing the current count value
);

// Internal signal to hold the next state of the counter
logic [3:0] next_out;

// Combinational logic to determine the next state of the counter
always @(*) begin
    if (!rst_n) begin
        next_out = 4'b0000;
    end else if (valid_count) begin
        // The counter naturally wraps around after reaching 4'd11
        next_out = out + 1;
    end else begin
        next_out = out;
    end
end

// Sequential logic to update the counter's state
always_ff @(posedge clk) begin
    out <= next_out;
end

endmodule