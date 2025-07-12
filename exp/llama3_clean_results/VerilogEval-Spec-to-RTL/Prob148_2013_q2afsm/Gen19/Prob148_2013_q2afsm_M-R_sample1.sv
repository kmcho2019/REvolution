module TopModule (
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

parameter STATE_A = 2'b00;
parameter STATE_B = 2'b01;
parameter STATE_C = 2'b10;
parameter STATE_D = 2'b11;

reg [1:0] state;

always @(posedge clk) begin
    if (~resetn) begin
        state <= STATE_A;
    end else begin
        case (state)
            STATE_A: state <= (r[0]) ? STATE_B : (r[1]) ? STATE_C : (r[2]) ? STATE_D : STATE_A;
            STATE_B: state <= (r[0]) ? STATE_B : STATE_A;
            STATE_C: state <= (r[1]) ? STATE_C : STATE_A;
            STATE_D: state <= (r[2]) ? STATE_D : STATE_A;
            default: state <= STATE_A;
        endcase
    end
end

assign g[0] = (state == STATE_B);
assign g[1] = (state == STATE_C);
assign g[2] = (state == STATE_D);

endmodule