module TopModule(
    input         clk,
    input         reset,
    input         slowena,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // synchronous reset
        q <= 4'd0;
    end else if (slowena) begin
        // increment counter
        if (q == 4'd9) begin
            q <= 4'd0;
        end else begin
            q <= q + 4'd1;
        end
    end
end

endmodule