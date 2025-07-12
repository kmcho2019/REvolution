module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4; // Set q to 4 when a=1
    end else begin
        // Increment q modulo 7, sequence cycles 4->5->6->0->1->2->3->4...
        // Add 1, wrap around at 7
        if (q == 3'd6) begin
            q <= 3'd0;
        end else if (q == 3'd3) begin
            q <= 3'd4;
        end else begin
            // Normal increment
            q <= q + 3'd1;
        end
    end
end

endmodule