module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 4'b0001;  // Reset to 1
    end else if (q == 4'd10) begin
        q <= 4'b0001;  // Roll over to 1
    end else begin
        q <= q + 1'b1;  // Increment
    end
end

endmodule