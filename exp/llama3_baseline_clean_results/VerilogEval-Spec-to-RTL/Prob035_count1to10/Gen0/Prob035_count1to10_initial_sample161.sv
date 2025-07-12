module TopModule(
    input  clk,
    input  reset,
    output reg [3:0] q
);

always @ (posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Reset to 1 (binary: 0001)
    end else if (q == 4'b1010) begin
        q <= 4'b0001;  // Count reached 10, wrap around to 1
    end else begin
        q <= q + 1;  // Increment count
    end
end

endmodule