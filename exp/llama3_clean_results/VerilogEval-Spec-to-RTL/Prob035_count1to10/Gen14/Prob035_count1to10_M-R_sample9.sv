module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

always @(*) begin
    if (reset) begin
        next_count = 4'd1; // Reset count to 1
    end else if (count == 4'd10) begin
        next_count = 4'd1; // Wrap around to 1 if count reaches 10
    end else begin
        next_count = count + 1; // Increment count if less than 10
    end
end

always @(posedge clk) begin
    count <= next_count;
end

assign q = count;

endmodule