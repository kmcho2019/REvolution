module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

reg [1:0] currentState, nextState;

// State transition logic and output
always @(*) begin
    case(currentState)
        A: if(!in) nextState = A; else nextState = B;
        B: if(!in) nextState = C; else nextState = B;
        C: if(!in) nextState = A; else nextState = D;
        D: if(!in) nextState = C; else nextState = B;
        default: nextState = A;
    endcase
    
    case(currentState)
        A, B, C: out = 0;
        D: out = 1;
    endcase
end

// Synchronous active high reset
always @(posedge clk or posedge reset) begin
    if(reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

endmodule