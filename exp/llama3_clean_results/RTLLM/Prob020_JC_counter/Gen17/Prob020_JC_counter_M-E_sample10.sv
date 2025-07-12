// Module JC_counter: 64-bit Johnson counter with pipelined architecture
module JC_counter(
    input clk,      // Clock signal
    input rst_n,    // Active-low reset signal
    output reg [63:0] Q  // 64-bit register representing the current count value
);

// Internal registers for pipelining
reg [63:0] reset_val;
reg [63:0] msb_val;
reg [63:0] shift_val;

// Stage 1: Reset Detection
always @(posedge clk) begin
    if (~rst_n) begin
        reset_val <= 64'd0; // Reset condition
    end else begin
        reset_val <= Q; // Pass through current value
    end
end

// Stage 2: Most Significant Bit (MSB) Determination
always @(posedge clk) begin
    if (reset_val[0] == 1'b0) begin
        msb_val <= {1'b1, reset_val[63:1]}; // Append 1 as MSB
    end else begin
        msb_val <= {1'b0, reset_val[63:1]}; // Append 0 as MSB
    end
end

// Stage 3: Shift and Append
always @(posedge clk) begin
    Q <= msb_val; // Update output
end

endmodule