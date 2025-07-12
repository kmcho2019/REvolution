module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] next_q;

always @(*) begin
    if (a) begin
        next_q = 3'd4;
    end else begin
        // Increment q modulo 7
        // States cycle through 4->5->6->0->1->2->3->4...
        if (q == 3'd6)
            next_q = 3'd0;
        else
            next_q = q + 3'd1;
    end
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule