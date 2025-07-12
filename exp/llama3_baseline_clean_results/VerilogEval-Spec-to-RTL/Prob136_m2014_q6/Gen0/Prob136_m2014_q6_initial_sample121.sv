module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states as an enumeration
typedef enum logic [3:0] {
    A = 4'b0000,
    B = 4'b0001,
    C = 4'b0010,
    D = 4'b0011,
    E = 4'b0100,
    F = 4'b0101
} state_t;

state_t current_state, next_state;

// Combinational logic to determine next state
always_comb begin
    case (current_state)
        A: next_state = (w) ? A : B;
        B: next_state = (w) ? D : C;
        C: next_state = (w) ? D : E;
        D: next_state = (w) ? A : F;
        E: next_state = (w) ? D : E;
        F: next_state = (w) ? D : C;
    endcase
end

// Sequential logic to update current state and determine output z
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Determine output z based on current state
always_comb begin
    case (current_state)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule