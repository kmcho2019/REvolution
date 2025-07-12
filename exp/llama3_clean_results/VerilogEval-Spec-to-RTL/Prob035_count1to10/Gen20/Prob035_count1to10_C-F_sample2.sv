module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

// Initialize count to 1 (binary 0001) to start counting from 1
always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1;
    end else if (count == 4'd10) begin
        count <= 4'd1;
    end else begin
        count <= count + 4'd1;
    end
end

// Directly assign count to output
assign q = count;

endmodule