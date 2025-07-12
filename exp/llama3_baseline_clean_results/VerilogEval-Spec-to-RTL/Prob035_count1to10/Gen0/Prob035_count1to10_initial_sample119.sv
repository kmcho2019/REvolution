module TopModule (
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'd1; // reset to 1
    end else if (count == 4'd10) begin
        count <= 4'd1; // reset to 1 after counting to 10
    end else begin
        count <= count + 4'd1; // increment counter
    end
end

assign q = count;

endmodule