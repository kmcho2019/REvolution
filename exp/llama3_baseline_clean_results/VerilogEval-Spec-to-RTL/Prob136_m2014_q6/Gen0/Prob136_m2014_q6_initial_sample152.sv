`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Enumerate states
enum {A, B, C, D, E, F} state, nextState;

// Determine next state based on current state and input
always @(*) begin
    case(state)
        A: nextState = (w == 0) ? B : A;
        B: nextState = (w == 0) ? C : D;
        C: nextState = (w == 0) ? E : D;
        D: nextState = (w == 0) ? F : A;
        E: nextState = (w == 0) ? E : D;
        F: nextState = (w == 0) ? C : D;
        default: nextState = A;
    endcase
end

// Update current state on positive edge of clock
always @(posedge clk) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= nextState;
    end
end

// Determine output based on current state and input
always @(*) begin
    case(state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

endmodule