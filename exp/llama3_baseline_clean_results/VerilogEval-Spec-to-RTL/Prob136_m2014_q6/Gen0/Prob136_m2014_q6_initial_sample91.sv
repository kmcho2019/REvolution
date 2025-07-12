// Define the states as an enumeration
enum logic [2:0] {A, B, C, D, E, F} state, next_state;

module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Combinational logic to determine the next state
always_comb begin
    case(state)
        A: next_state = (w)? A : B;
        B: next_state = (w)? D : C;
        C: next_state = (w)? D : E;
        D: next_state = (w)? A : F;
        E: next_state = (w)? D : E;
        F: next_state = (w)? D : C;
        default: next_state = A;
    endcase
end

// Sequential logic to update the current state
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Output logic to determine 'z'
always_comb begin
    case(state)
        A, B, C, D: z = 0;
        E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule