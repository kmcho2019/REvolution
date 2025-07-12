`timescale 1ns/1ps

module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output out
);

// Define the states of the state machine
enum logic [0:0] {OFF, ON} state, next_state;

// Assign output out based on the current state
assign out = (state == ON) ? 1'b1 : 1'b0;

// State machine logic
always @(*) begin
    case(state)
        OFF: begin
            if (j) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if (k) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

// Asynchronous reset state machine
always @(posedge clk or posedge areset) begin
    if (areset) state <= OFF;
    else state <= next_state;
end

endmodule