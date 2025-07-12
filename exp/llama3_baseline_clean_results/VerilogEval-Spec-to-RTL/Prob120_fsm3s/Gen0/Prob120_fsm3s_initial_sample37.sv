`timescale 1ns/1ps

module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

// Define the states as an enumeration
enum logic [1:0] {A, B, C, D} current_state, next_state;

// Output logic
always_comb begin
    case(current_state)
        A, B, C: out = 0;
        D: out = 1;
        default: out = 0;
    endcase
end

// State transition logic
always @ (posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case(current_state)
            A: current_state <= in ? B : A;
            B: current_state <= in ? B : C;
            C: current_state <= in ? D : A;
            D: current_state <= in ? B : C;
            default: current_state <= A;
        endcase
    end
end

endmodule