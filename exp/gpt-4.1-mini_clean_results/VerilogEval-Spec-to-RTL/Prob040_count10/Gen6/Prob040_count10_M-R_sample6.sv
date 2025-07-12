module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

// Combinational next state logic via continuous assignment
wire [3:0] next_q = (q == 4'd9) ? 4'd0 : (q + 4'd1);

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= next_q;
end

endmodule