module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

reg [2:0] state, nextState;

always @(state or w) begin
    case(state)
        A: nextState = w ? B : A;
        B: nextState = w ? C : D;
        C: nextState = w ? E : D;
        D: nextState = w ? F : A;
        E: nextState = w ? E : D;
        F: nextState = w ? C : D;
        default: nextState = A;
    endcase
end

always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

assign z = (state == E) || (state == F);

endmodule