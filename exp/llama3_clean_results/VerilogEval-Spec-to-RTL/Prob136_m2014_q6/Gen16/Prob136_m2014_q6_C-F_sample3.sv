module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using gray code encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// State register
reg [2:0] currentState;

// Combinational logic for next state
reg [2:0] nextState;
always @(*) begin
    case (currentState)
        A: nextState = w ? A : B;
        B: nextState = w ? D : C;
        C: nextState = w ? D : E;
        D: nextState = w ? A : F;
        E: nextState = w ? D : E;
        F: nextState = w ? D : C;
        default: nextState = A;
    endcase
end

// Alternatively, use a combination of multiplexers and logic gates
// wire [2:0] nextState_mux;
// assign nextState_mux = (currentState == A) ? (w ? A : B) : 
//                         (currentState == B) ? (w ? D : C) : 
//                         (currentState == C) ? (w ? D : E) : 
//                         (currentState == D) ? (w ? A : F) : 
//                         (currentState == E) ? (w ? D : E) : 
//                         (currentState == F) ? (w ? D : C) : A;
// assign nextState = nextState_mux;

// Combinational logic for output z
assign z = (currentState == E) || (currentState == F);

// Update the state on the positive edge of the clock
always @(posedge clk) begin
    if (reset) currentState <= A;
    else currentState <= nextState;
end

endmodule