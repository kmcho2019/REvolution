module TopModule(
    input           clk,
    input           reset,
    input           slowena,
    output reg [3:0] q
);

    always @(posedge clk) begin
        if (reset) begin
            // Synchronous reset to 0
            q <= 4'd0;
        end else if (slowena) begin
            // Increment the counter if slowena is high
            if (q < 4'd10) begin
                q <= q + 1;
            end else begin
                // Wrap the counter around to 0
                q <= 4'd0;
            end
        end
    end

endmodule