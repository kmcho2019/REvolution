module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1;  // Reset the counter to 1 (binary 0001)
    end else if (count == 4'd10) begin
        count <= 4'd10;  // Stay at 10 if already there
    end else begin
        count <= count + 4'd1;  // Increment the counter
    end
end

assign q = count;

endmodule