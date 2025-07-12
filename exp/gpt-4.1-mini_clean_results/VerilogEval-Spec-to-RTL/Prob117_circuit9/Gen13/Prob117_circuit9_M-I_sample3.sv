module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

wire [2:0] next_q;

// Next state logic: if a==1, force 4; else increment modulo 7 (0 to 6 cycle)
assign next_q = a ? 3'd4 : ((q == 3'd6) ? 3'd0 : q + 3'd1);

always @(posedge clk) begin
    // Update q only if next_q differs to reduce toggling
    if (q != next_q)
        q <= next_q;
end

endmodule