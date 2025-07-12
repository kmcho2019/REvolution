module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 4'b0001; // Initialize count to 1

always @(posedge clk) begin
    if (reset || count == 4'd10) begin
        count <= 4'b0001; // Reset to 1 or wrap around to 1 if count is 10
    end else begin
        count <= count + 1; // Increment count
    end
end

assign q = count;

endmodule