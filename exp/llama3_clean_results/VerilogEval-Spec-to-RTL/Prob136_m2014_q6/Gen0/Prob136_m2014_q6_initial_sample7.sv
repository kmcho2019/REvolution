`timescale 1ns / 1ps

module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} currentState, nextState;

// State transition logic
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
    end else begin
        currentState <= nextState;
    end
end

// Determine next state and output z
always @(*) begin
    case (currentState)
        A: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = B;
            end
            z = 0;
        end
        B: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
            z = 0;
        end
        C: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
            z = 0;
        end
        D: begin
            if (w) begin
                nextState = A;
            end else begin
                nextState = F;
            end
            z = 0;
        end
        E: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = E;
            end
            z = 1;
        end
        F: begin
            if (w) begin
                nextState = D;
            end else begin
                nextState = C;
            end
            z = 1;
        end
        default: begin
            nextState = A;
            z = 0;
        end
    endcase
end

endmodule