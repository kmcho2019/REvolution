module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

reg [2:0] currentState;
reg [2:0] nextState;

always @(*) begin
    case(currentState)
        A: nextState = (w == 1) ? A : B;
        B: nextState = (w == 1) ? D : C;
        C: nextState = (w == 1) ? D : E;
        D: nextState = (w == 1) ? A : F;
        E: nextState = (w == 1) ? D : E;
        F: nextState = (w == 1) ? D : C;
        default: nextState = A;
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

assign z = (currentState == E) || (currentState == F);

endmodule