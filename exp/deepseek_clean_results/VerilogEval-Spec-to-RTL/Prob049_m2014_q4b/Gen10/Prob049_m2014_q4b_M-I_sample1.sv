module TopModule (
    input  wire clk,  // Clock input
    input  wire ar,   // Asynchronous reset (active high)
    input  wire d,    // Data input
    output reg  q     // Data output
);

// Clock gating logic
wire gated_clk;
reg last_d;
assign gated_clk = clk & (d != last_d);

always @(posedge clk) begin
    last_d <= d;
end

// Optimized flip-flop with clock gating and async reset
always @(posedge gated_clk or posedge ar) begin
    if (ar) begin
        q <= 1'b0;    // Async reset has priority
    end else begin
        q <= d;       // Normal operation
    end
end

endmodule