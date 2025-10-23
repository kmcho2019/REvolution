module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

parameter B = 1'b0, A = 1'b1;

reg state, next_state;

always @(*) begin
    case(state)
        B: begin
            if(!in) next_state = A;
            else next_state = B;
        end
        A: begin
            if(!in) next_state = B;
            else next_state = A;
        end
        default: next_state = B;
    endcase
end

always @(posedge clk) begin
    if(reset) state <= B;
    else state <= next_state;
end

assign out = (state == B) ? 1'b1 : 1'b0;

endmodule