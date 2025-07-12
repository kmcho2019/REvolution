module TopModule(
    input clk,
    input d,
    input r,
    output reg q
);

wire next_q;

// Next state logic: synchronous reset takes priority, else follow d
assign next_q = r ? 1'b0 : d;

always @(posedge clk) begin
    if (q != next_q)
        q <= next_q;
    // else hold q to reduce unnecessary toggling
end

endmodule