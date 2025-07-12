module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 3'd4; // Hold q=4 when a=1
    end else begin
        // Increment modulo 7: cycle 4->5->6->0->1->2->3->4...
        // If q == 6 wrap to 0 else q+1
        next_q = (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

always @(posedge clk) begin
    // Update q only if value changes to reduce register toggling
    if (q != next_q)
        q <= next_q;
end

endmodule