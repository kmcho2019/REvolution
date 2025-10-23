module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Reset count to 1
    end else begin
        if (count == 4'd10) begin
            count <= 4'd1; // Wrap around to 1 after 10
        end else begin
            count <= count + 4'd1; // Increment count by 1
        end
    end
end

assign q = count;

endmodule