module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output reg out
);

reg state; // 1-bit signal to represent the current state

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 1'b0; // reset to OFF state
    end else begin
        case(state)
            1'b0: state <= j; // OFF state: transition to ON if j=1, stay in OFF if j=0
            1'b1: state <= ~k; // ON state: transition to OFF if k=1, stay in ON if k=0
        endcase
    end
end

always @(*) begin
    case(state)
        1'b0: out = 1'b0; // output is 0 in OFF state
        1'b1: out = 1'b1; // output is 1 in ON state
    endcase
end

endmodule