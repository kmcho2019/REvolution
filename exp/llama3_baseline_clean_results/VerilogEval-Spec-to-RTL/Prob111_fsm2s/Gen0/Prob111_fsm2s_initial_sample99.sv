module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [0:0] state; // Current state: 0 - OFF, 1 - ON
reg [0:0] nextState; // Next state

// State encoding
parameter OFF = 0, ON = 1;

always @(*) begin
    case(state)
        OFF: 
            if(j == 1'b1) 
                nextState = ON;
            else 
                nextState = OFF;
        ON: 
            if(k == 1'b1) 
                nextState = OFF;
            else 
                nextState = ON;
        default: 
            nextState = OFF;
    endcase
end

always @(posedge clk or posedge reset) begin
    if(reset == 1'b1) 
        state <= OFF;
    else 
        state <= nextState;
end

assign out = (state == ON) ? 1'b1 : 1'b0;

endmodule