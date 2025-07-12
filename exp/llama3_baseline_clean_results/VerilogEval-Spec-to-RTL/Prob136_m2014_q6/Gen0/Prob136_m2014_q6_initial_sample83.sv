module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
enum logic [2:0] {A, B, C, D, E, F} current_state, next_state;

// Output z is 1 for states E and F, and 0 otherwise
assign z = (current_state == E || current_state == F) ? 1'b1 : 1'b0;

// Sequential logic
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic
always_comb begin
    case (current_state)
        A: next_state = w ? A : B;
        B: next_state = w ? D : C;
        C: next_state = w ? D : E;
        D: next_state = w ? A : F;
        E: next_state = w ? D : E;
        F: next_state = w ? D : C;
    endcase
end

endmodule