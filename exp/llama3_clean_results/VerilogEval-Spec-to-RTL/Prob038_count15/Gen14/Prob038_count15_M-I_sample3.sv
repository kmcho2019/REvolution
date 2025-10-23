module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        q <= 4'd0;
    end else begin
        // Direct incrementation for simplicity and efficiency
        // Handling overflow explicitly for clarity
        if (q == 4'd15) begin
            q <= 4'd0;
        end else begin
            q <= q + 1'd1;
        end
    end
end

endmodule