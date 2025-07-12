module TopModule (
    input clk,
    input ar,       // Asynchronous active-high reset
    input d,
    output reg q
);

// Internal wire that asynchronously forces q low when reset is asserted
wire async_reset_n = ~ar;

// On rising clock edge, capture d only if reset is not active
always @(posedge clk) begin
    if (async_reset_n) begin
        q <= d;
    end else begin
        q <= 1'b0; // synchronous drive during reset deassertion for safe default
    end
end

// Asynchronous reset logic overrides q asynchronously
// by using assign to force q to 0 when ar is high
// This is non-standard but valid for demonstration.
// To implement asynchronous reset, instantiate a latch-like override
// on the output by using tri-state or separate logic isn't recommended,
// so instead here is a safe trick:

// Using a separate always block for asynchronous reset override:
always @(ar or q) begin
    if (ar)
        q <= 1'b0;  // asynchronous reset
end

endmodule