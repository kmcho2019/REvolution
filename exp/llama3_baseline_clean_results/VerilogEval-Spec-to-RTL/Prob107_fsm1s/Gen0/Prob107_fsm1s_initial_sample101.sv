module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

localparam STATE_B = 1'b0;
localparam STATE_A = 1'b1;

reg current_state;
reg next_state;

always @(*) begin
    case(current_state)
        STATE_B: begin
            if (~in) next_state = STATE_A;
            else next_state = STATE_B;
        end
        STATE_A: begin
            if (~in) next_state = STATE_B;
            else next_state = STATE_A;
        end
        default: next_state = STATE_B;
    endcase
end

always @(posedge clk) begin
    if (reset) begin
        current_state <= STATE_B;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    case(current_state)
        STATE_B: out = 1'b1;
        STATE_A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule