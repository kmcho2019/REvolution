module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk) begin
    if (a) begin
        q <= 3'd4;  // Reset condition
    end
    else begin
        if (q == 3'd6) begin
            q <= 3'd0;  // Wrap-around
        end
        else begin
            q <= q + 1;  // Normal increment
        end
    end
end

endmodule