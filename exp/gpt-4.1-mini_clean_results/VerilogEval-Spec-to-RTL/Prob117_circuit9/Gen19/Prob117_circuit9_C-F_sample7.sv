module TopModule (
    input        clk,
    input        a,
    output reg [2:0] q
);

reg [2:0] next_state;

always @(*) begin
    if (a) begin
        next_state = 3'd4;
    end else begin
        // Modulo-7 counting sequence: 4->5->6->0->1->2->3->4...
        next_state = (q == 3'd6) ? 3'd0 : q + 3'd1;
    end
end

always @(posedge clk) begin
    if (q !== next_state)
        q <= next_state;
end

endmodule