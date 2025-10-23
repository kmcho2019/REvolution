module TopModule (
    input  wire clk,  // Clock input
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output reg  q     // Data output
);

// Internal signals
reg d_prev;          // Previous data value for clock gating
wire gated_clk;      // Gated clock signal

// Clock gating logic - only enable clock when input changes
assign gated_clk = clk & (ar | (d != d_prev));

// Positive edge-triggered D flip-flop with async reset
always @(posedge gated_clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;    // Async reset has priority
    end else begin
        q <= d;       // Normal operation
    end
end

// Track previous input value for clock gating
always @(posedge clk or posedge ar) begin
    if (ar) begin
        d_prev <= 1'b0;
    end else begin
        d_prev <= d;
    end
end

endmodule