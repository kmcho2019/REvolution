module TopModule(
    input  clk,
    input  reset,
    input  x,
    output z
);

parameter S0 = 3'b000;
parameter S1 = 3'b001;
parameter S2 = 3'b010;
parameter S3 = 3'b011;
parameter S4 = 3'b100;

reg [2:0] state, nextState;
assign z = (state == S3 || state == S4) ? 1'b1 : 1'b0;

always @(*)
begin
    case(state)
        S0: nextState = x ? S1 : S0;
        S1: nextState = x ? S4 : S1;
        S2: nextState = x ? S1 : S2;
        S3: nextState = x ? S2 : S1;
        S4: nextState = x ? S4 : S3;
        default: nextState = S0;
    endcase
end

always @(posedge clk)
begin
    if(reset)
        state <= S0;
    else
        state <= nextState;
end

endmodule