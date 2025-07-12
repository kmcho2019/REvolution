module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count = 4'd1; // Initialize count to 1
reg [3:0] next_count; // Next state register

always @(*) begin
    if (reset || count == 4'd10) begin
        next_count = 4'd1; // Reset to 1 or wrap around to 1 if count is 10
    end else begin
        next_count = count + 1; // Increment count
    end
end

always @(posedge clk) begin
    count <= next_count; // Update count
end

assign q = count;

endmodule