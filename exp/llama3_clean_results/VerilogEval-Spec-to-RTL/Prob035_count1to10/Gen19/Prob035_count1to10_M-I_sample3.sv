module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // Explicitly setting the reset value to 1 using decimal notation for clarity
    end else if (count == 4'd10) begin
        count <= 4'd1; // Using decimal notation for the overflow condition
    end else begin
        count <= count + 1'd1; // Incrementing by 1 using decimal notation for consistency
    end
end

assign q = count;

endmodule