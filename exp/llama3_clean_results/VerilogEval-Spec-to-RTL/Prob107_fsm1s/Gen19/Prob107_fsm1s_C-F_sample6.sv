module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

parameter STATE_B = 1'b0, STATE_A = 1'b1;
reg state;

assign out = ~state;

always @(posedge clk) begin
    if (reset) begin
        state <= STATE_B;
    end else begin
        case(state)
            STATE_B: state <= in ? STATE_B : STATE_A;
            STATE_A: state <= in ? STATE_A : STATE_B;
            default: state <= STATE_B; // Default state
        endcase
    end
end

endmodule