module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 4'b0001; // Initialize count to 1

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0001; // Reset to 1
    end else begin
        count <= (count == 4'd10) ? 4'b0001 : count + 1; // Simplified comparison and increment
    end
end

assign q = count;

endmodule