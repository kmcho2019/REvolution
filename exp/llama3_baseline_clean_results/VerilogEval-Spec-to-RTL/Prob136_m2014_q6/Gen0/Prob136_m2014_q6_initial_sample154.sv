module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] currentState, nextState;
wire [2:0] stateA = 3'b000;
wire [2:0] stateB = 3'b001;
wire [2:0] stateC = 3'b010;
wire [2:0] stateD = 3'b011;
wire [2:0] stateE = 3'b100;
wire [2:0] stateF = 3'b101;

assign z = (currentState == stateE) || (currentState == stateF);

always @(*)
begin
    case(currentState)
        stateA: 
            if(w) 
                nextState = stateA;
            else 
                nextState = stateB;
        stateB: 
            if(w) 
                nextState = stateD;
            else 
                nextState = stateC;
        stateC: 
            if(w) 
                nextState = stateD;
            else 
                nextState = stateE;
        stateD: 
            if(w) 
                nextState = stateA;
            else 
                nextState = stateF;
        stateE: 
            if(w) 
                nextState = stateD;
            else 
                nextState = stateE;
        stateF: 
            if(w) 
                nextState = stateD;
            else 
                nextState = stateC;
        default: 
            nextState = stateA;
    endcase
end

always @(posedge clk or posedge reset)
begin
    if(reset)
        currentState <= stateA;
    else
        currentState <= nextState;
end

endmodule