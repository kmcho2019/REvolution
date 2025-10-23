module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

reg [3:0] next_q;

always @(*) begin
    case (q)
        4'd0:  next_q = 4'd1;
        4'd1:  next_q = 4'd2;
        4'd2:  next_q = 4'd3;
        4'd3:  next_q = 4'd4;
        4'd4:  next_q = 4'd5;
        4'd5:  next_q = 4'd6;
        4'd6:  next_q = 4'd7;
        4'd7:  next_q = 4'd8;
        4'd8:  next_q = 4'd9;
        4'd9:  next_q = 4'd0;
        default: next_q = 4'd0;  // Safe default to avoid X states
    endcase
end

always @(posedge clk) begin
    if (reset)
        q <= 4'd0;
    else
        q <= next_q;
end

endmodule