module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;
reg [3:0] next_count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Synchronous reset to 1
    end else if (count == 4'd10) begin
        count <= 4'd1; // Wrap around to 1
    end else begin
        count <= count + 1; // Increment count
    end
end

always @(*) begin
    if (reset) begin
        next_count = 4'd1; // Synchronous reset to 1
    end else if (count == 4'd10) begin
        next_count = 4'd1; // Wrap around to 1
    end else begin
        next_count = count + 1; // Increment count
    end
end

assign q = count;

endmodule