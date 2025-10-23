module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // load 4 when a is high
    end else begin
        // Increment q modulo 7: states cycle 4->5->6->0->1->2->3->4...
        if (q == 3'd6)
            q <= 3'd0;
        else
            q <= q + 3'd1;
    end
end

endmodule