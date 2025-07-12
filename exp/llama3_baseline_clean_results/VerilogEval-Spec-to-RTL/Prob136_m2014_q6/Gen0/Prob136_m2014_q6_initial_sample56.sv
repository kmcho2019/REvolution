module TopModule(
    input  clk,
    input  reset,
    input  w,
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

// Declare the current state and next state variables
state_t current_state;
state_t next_state;

// Output logic
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

// State transition logic
always_comb begin
    case (current_state)
        A: begin
            if (w == 1'b1)
                next_state = A;
            else
                next_state = B;
        end
        B: begin
            if (w == 1'b1)
                next_state = D;
            else
                next_state = C;
        end
        C: begin
            if (w == 1'b1)
                next_state = D;
            else
                next_state = E;
        end
        D: begin
            if (w == 1'b1)
                next_state = A;
            else
                next_state = F;
        end
        E: begin
            if (w == 1'b1)
                next_state = D;
            else
                next_state = E;
        end
        F: begin
            if (w == 1'b1)
                next_state = D;
            else
                next_state = C;
        end
        default: next_state = A;
    endcase
end

// State register
always_ff @(posedge clk or posedge reset) begin
    if (reset == 1'b1)
        current_state <= A;
    else
        current_state <= next_state;
end

endmodule