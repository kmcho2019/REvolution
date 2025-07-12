module TopModule(
    input  clk,
    input  reset,
    output [3:0] q
);

reg [3:0] counter;

always @(posedge clk) begin
    counter <= (reset || counter == 4'd9) ? 4'd0 : counter + 4'd1;
end

assign q = counter;

endmodule