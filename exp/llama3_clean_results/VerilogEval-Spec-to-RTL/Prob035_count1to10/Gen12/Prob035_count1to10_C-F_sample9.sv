module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg clk_enable;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset count to 1 synchronously
        clk_enable <= 1'b1; // Enable clock after reset
    end else if (count < 4'd10) begin
        count <= count + 1; // Increment count if less than 10
    end else begin
        count <= 4'd1; // Wrap around to 1 if count reaches 10
    end
end

always @(posedge clk) begin
    if (count == 4'd10) begin
        clk_enable <= 1'b0; // Disable clock when count reaches 10
    end else begin
        clk_enable <= 1'b1; // Enable clock otherwise
    end
end

assign q = count;

endmodule