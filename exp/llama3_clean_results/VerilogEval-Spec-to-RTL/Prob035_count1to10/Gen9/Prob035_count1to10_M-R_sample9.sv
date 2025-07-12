module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [2:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 3'd0; // Reset count to 0 (which corresponds to output 1)
    end else if (count == 3'd9) begin
        count <= 3'd0; // Wrap around to 0 after 9
    end else begin
        count <= count + 1; // Increment count by 1
    end
end

assign q = (count == 3'd9) ? 4'd10 : {1'b0, count} + 1; // Drive output q based on count

endmodule