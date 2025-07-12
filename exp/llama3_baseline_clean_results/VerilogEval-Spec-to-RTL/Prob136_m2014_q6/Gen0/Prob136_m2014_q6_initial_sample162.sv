module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define the states
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

state_t current_state;
state_t next_state;

// Determine the output 'z' based on the current state
always_comb begin
    case(current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

// Determine the next state based on the current state and input 'w'
always_comb begin
    case(current_state)
        A: begin
            if (w) next_state = A;
            else next_state = B;
        end
        B: begin
            if (w) next_state = D;
            else next_state = C;
        end
        C: begin
            if (w) next_state = D;
            else next_state = E;
        end
        D: begin
            if (w) next_state = A;
            else next_state = F;
        end
        E: begin
            if (w) next_state = D;
            else next_state = E;
        end
        F: begin
            if (w) next_state = D;
            else next_state = C;
        end
        default: next_state = A;
    endcase
end

// Update the current state on the positive edge of the clock
always_ff @(posedge clk) begin
    if (reset) current_state <= A;
    else current_state <= next_state;
end

endmodule