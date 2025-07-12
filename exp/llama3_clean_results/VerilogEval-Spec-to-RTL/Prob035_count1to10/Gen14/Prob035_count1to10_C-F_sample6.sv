module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset || count == 4'd10) begin
        count <= 4'd1; // Reset to 1 when reset is high or count reaches 10
    end else begin
        count <= count + 1; // Increment count by 1
    end
end

assign q = count; // Assign count to output q

endmodule