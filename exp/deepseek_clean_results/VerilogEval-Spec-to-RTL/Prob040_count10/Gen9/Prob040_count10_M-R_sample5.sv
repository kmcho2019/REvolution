module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

wire [3:0] next_q;

always @(*) begin
    case (1'b1)
        reset:      next_q = 4'b0000;
        (q == 9):   next_q = 4'b0000;
        default:    next_q = q + 1'b1;
    endcase
end

always @(posedge clk) begin
    q <= next_q;
end

endmodule