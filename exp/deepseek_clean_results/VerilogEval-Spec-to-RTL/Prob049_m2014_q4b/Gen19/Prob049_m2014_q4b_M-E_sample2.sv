module TopModule (
    input clk,
    input ar,
    input d,
    output reg q
);

reg d_prev;
wire gated_clk;

// Detect changes in input data
always @(d) begin
    d_prev <= d;
end

// Create gated clock - only active when input changes
assign gated_clk = clk & (d != d_prev);

// Main flip-flop with asynchronous reset
always @(posedge gated_clk or posedge ar) begin
    if (ar) q <= 1'b0;
    else    q <= d;
end

endmodule