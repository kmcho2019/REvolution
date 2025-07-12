module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        count <= 4'b0001; // Reset to 1
    end else begin
        count <= (count == 4'd10)? 4'b0001 : count + 1; // Increment or wrap around
    end
end

assign q = count;

endmodule