module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // synchronous load to 4
    end else begin
        // increment modulo 7, sequence is 4->5->6->0->1->2->3->4...
        if (q == 3'd3)
            q <= 3'd4;
        else
            q <= (q + 3'd1) % 3'd7;
    end
end

endmodule