module TopModule(
    input clk,
    input reset,
    output reg [3:0] q
);

always @ (posedge clk) begin
    if (reset) begin
        q <= 4'b0001; // Reset to 1
    end else if (q == 4'd10) begin
        q <= 4'b0001; // Reset to 1 when count reaches 10
    end else begin
        q <= q + 1; // Increment the counter
    end
end

endmodule