module TopModule (
    input clk,
    input d,
    input r,
    output reg q
);

// Standard synchronous reset D flip-flop with active-high reset
// Synthesis-friendly: single always block, no extra combinational logic
always @(posedge clk) begin
    if (r)
        q <= 1'b0;
    else
        q <= d;
end

endmodule