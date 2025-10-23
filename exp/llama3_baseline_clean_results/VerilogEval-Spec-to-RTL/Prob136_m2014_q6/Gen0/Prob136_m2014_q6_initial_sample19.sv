`timescale 1ns/1ps

module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
enum {A, B, C, D, E, F} state, next_state;

// Combinational logic to determine the next state
always_comb begin
    case (state)
        A: begin
            if (w) next_state = A;
            else   next_state = B;
        end
        B: begin
            if (w) next_state = D;
            else   next_state = C;
        end
        C: begin
            if (w) next_state = D;
            else   next_state = E;
        end
        D: begin
            if (w) next_state = A;
            else   next_state = F;
        end
        E: begin
            if (w) next_state = D;
            else   next_state = E;
        end
        F: begin
            if (w) next_state = D;
            else   next_state = C;
        end
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk) begin
    if (reset) state <= A;
    else       state <= next_state;
end

// Determine the output z based on the current state
assign z = (state == E || state == F)? 1'b1 : 1'b0;

endmodule