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

// Define the current state and next state
state_t state, next_state;

// Define the output z based on the current state
always_comb begin
    case(state)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'bx;
    endcase
end

// Define the next state based on the current state and input w
always_comb begin
    case(state)
        A: next_state = (w == 1'b0) ? B : A;
        B: next_state = (w == 1'b0) ? C : D;
        C: next_state = (w == 1'b0) ? E : D;
        D: next_state = (w == 1'b0) ? F : A;
        E: next_state = (w == 1'b0) ? E : D;
        F: next_state = (w == 1'b0) ? C : D;
        default: next_state = A;
    endcase
end

// Update the current state on the positive edge of the clock
always_ff @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

endmodule