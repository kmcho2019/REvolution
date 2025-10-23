module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

// Sequential logic to update count
always @(posedge clk) begin
    if (reset) begin
        count <= 1;
    end else if (count == 4'd10) begin
        count <= 1;
    end else begin
        count <= count + 1;
    end
end

// Directly assign count to output
assign q = count;

endmodule