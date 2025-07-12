module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire ce = ~reset & (q != 4'd9);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else if (ce)
        q <= q + 4'd1;
    else if (q == 4'd9)
        q <= 4'd0;
end

endmodule