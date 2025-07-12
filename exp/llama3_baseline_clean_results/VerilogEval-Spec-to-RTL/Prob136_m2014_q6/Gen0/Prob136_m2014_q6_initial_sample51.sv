module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states as an enumeration
enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state, next_state;

// Handle state transitions
always @(*) begin
    case (state)
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

// Update the state at each clock edge
always @(posedge clk, posedge reset) begin
    if (reset) state <= A;
    else state <= next_state;
end

// Assign output 'z' based on the current state
always @(*) begin
    case (state)
        A, B, C, D: z = 0;
        E, F: z = 1;
        default: z = 0;
    endcase
end

endmodule