module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 4'b0001; // Initialize count to 1

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0001; // Reset to 1
    end else if (count < 4'd10) begin
        count <= count + 1; // Increment count if less than 10
    end else begin
        count <= 4'b0001; // Wrap around to 1 if count reaches 10
    end
end

assign q = count;

endmodule