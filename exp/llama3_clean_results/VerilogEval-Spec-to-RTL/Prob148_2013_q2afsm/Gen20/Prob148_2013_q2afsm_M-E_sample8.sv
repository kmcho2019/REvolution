module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the state modules
module StateA(
    input  [2:0] r,
    output [1:0] nextState
);
    always @(*) begin
        if (r[0]) nextState = 2'b01; // If r[0] is high, go to state B
        else if (r[1]) nextState = 2'b10; // If r[1] is high, go to state C
        else if (r[2]) nextState = 2'b11; // If r[2] is high, go to state D
        else nextState = 2'b00; // Otherwise, stay in state A
    end
endmodule

module StateB(
    input  r0,
    output [1:0] nextState
);
    always @(*) begin
        if (!r0) nextState = 2'b00; // If r[0] is low, go to state A
        else nextState = 2'b01; // Otherwise, stay in state B
    end
endmodule

module StateC(
    input  r1,
    output [1:0] nextState
);
    always @(*) begin
        if (!r1) nextState = 2'b00; // If r[1] is low, go to state A
        else nextState = 2'b10; // Otherwise, stay in state C
    end
endmodule

module StateD(
    input  r2,
    output [1:0] nextState
);
    always @(*) begin
        if (!r2) nextState = 2'b00; // If r[2] is low, go to state A
        else nextState = 2'b11; // Otherwise, stay in state D
    end
endmodule

// Instantiate the state modules
StateA stateA(.r(r),.nextState(nextStateA));
StateB stateB(.r0(r[0]),.nextState(nextStateB));
StateC stateC(.r1(r[1]),.nextState(nextStateC));
StateD stateD(.r2(r[2]),.nextState(nextStateD));

// Define the next state logic
reg [1:0] state;
always @(posedge clk) begin
    if (~resetn) state <= 2'b00; // Reset to state A
    else begin
        case (state)
            2'b00: state <= nextStateA; // State A
            2'b01: state <= nextStateB; // State B
            2'b10: state <= nextStateC; // State C
            2'b11: state <= nextStateD; // State D
            default: state <= 2'b00; // Default to state A
        endcase
    end
end

// Define the output logic
assign g[0] = (state == 2'b01); // g[0] is high in state B
assign g[1] = (state == 2'b10); // g[1] is high in state C
assign g[2] = (state == 2'b11); // g[2] is high in state D

endmodule