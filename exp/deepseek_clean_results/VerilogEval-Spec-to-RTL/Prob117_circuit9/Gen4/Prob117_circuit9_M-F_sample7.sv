module TopModule (
    input clk,
    input a,
    output reg [2:0] q
);

reg [2:0] counter;

always @(posedge clk) begin
    if (a) begin
        counter <= 3'd4;  // reset to 4 when a=1
    end else begin
        counter <= (counter == 3'd6) ? 3'd0 : counter + 3'd1;
    end
    q <= a ? 3'd4 : counter;  // synchronous output
end

endmodule