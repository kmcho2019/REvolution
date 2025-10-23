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
reg [1:0] next_state;

always @(posedge clk) begin
    if (~resetn) begin
        state <= STATE_A;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        STATE_A: next_state = (r[0]) ? STATE_B : (r[1]) ? STATE_C : (r[2]) ? STATE_D : STATE_A;
        STATE_B: next_state = (r[0]) ? STATE_B : STATE_A;
        STATE_C: next_state = (r[1]) ? STATE_C : STATE_A;
        STATE_D: next_state = (r[2]) ? STATE_D : STATE_A;
        default: next_state = STATE_A;
    endcase
end

always @(*) begin
    case (state)
        STATE_A: begin
            g[0] = 0;
            g[1] = 0;
            g[2] = 0;
        end
        STATE_B: begin
            g[0] = 1;
            g[1] = 0;
            g[2] = 0;
        end
        STATE_C: begin
            g[0] = 0;
            g[1] = 1;
            g[2] = 0;
        end
        STATE_D: begin
            g[0] = 0;
            g[1] = 0;
            g[2] = 1;
        end
        default: begin
            g[0] = 0;
            g[1] = 0;
            g[2] = 0;
        end
    endcase
end

endmodule