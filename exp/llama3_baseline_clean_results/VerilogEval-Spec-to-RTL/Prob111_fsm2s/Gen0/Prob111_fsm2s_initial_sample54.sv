module TopModule(
    input       clk,
    input       reset,
    input       j,
    input       k,
    output      out
);

reg [0:0] state; // 0: OFF, 1: ON
reg [0:0] nextState;

always @(*) begin
    case(state)
        0'b0: // OFF
            if(j)
                nextState = 1'b1; // transition to ON
            else
                nextState = 1'b0; // stay in OFF
        1'b1: // ON
            if(k)
                nextState = 1'b0; // transition to OFF
            else
                nextState = 1'b1; // stay in ON
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 1'b0; // reset to OFF state
    end else begin
        state <= nextState;
    end
end

assign out = state;

endmodule