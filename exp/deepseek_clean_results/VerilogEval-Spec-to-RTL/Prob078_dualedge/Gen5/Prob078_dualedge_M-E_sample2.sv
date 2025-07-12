module TopModule (
    input clk,
    input d,
    output reg q
);

wire latch_high_out, latch_low_out;

// High-active transparent latch
assign latch_high_out = clk ? d : latch_high_out;

// Low-active transparent latch
assign latch_low_out = ~clk ? d : latch_low_out;

// Combine latch outputs (only one is transparent at a time)
wire combined_out = latch_high_out | latch_low_out;

// Final synchronization flip-flop
always @(posedge clk) begin
    q <= combined_out;
end

endmodule