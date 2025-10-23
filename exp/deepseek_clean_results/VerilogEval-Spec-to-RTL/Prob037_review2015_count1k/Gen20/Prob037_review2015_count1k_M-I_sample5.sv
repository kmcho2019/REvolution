module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

always @(posedge clk) begin
    if (reset)
        q <= 10'b0;
    else
        q <= (q == 10'b1111100111) ? 10'b0 : q + 1'b1;
end

endmodule