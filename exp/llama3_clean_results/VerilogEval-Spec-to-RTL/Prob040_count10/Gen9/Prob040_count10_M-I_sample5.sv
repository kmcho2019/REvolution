module TopModule(
    input clk,
    input reset,
    output [3:0] q
);

reg [3:0] count;

always @(posedge clk) begin
    if (reset) begin
        // Synchronous reset to 0
        count <= 4'd0;
    end else begin
        // Increment count, wrapping around to 0 after 9
        count <= (count == 4'd9) ? 4'd0 : (count + 1'b1);
    end
end

assign q = count;

endmodule