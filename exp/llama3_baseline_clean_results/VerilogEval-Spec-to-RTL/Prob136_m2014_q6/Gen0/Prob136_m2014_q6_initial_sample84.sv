module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define states as an enum
typedef enum logic [2:0] {
    A = 3'b000,
    B = 3'b001,
    C = 3'b010,
    D = 3'b011,
    E = 3'b100,
    F = 3'b101
} state_t;

// Variable to keep track of the current state
state_t current_state, next_state;

// Output 'z' is 1 if we're in state E or F, and 0 otherwise
assign z = (current_state == E || current_state == F);

// Sequential logic
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for state transitions
always_comb begin
    case (current_state)
        A: begin
            if (w == 1'b1) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        C: begin
            if (w == 1'b1) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        D: begin
            if (w == 1'b1) begin
                next_state = A;
            end else begin
                next_state = F;
            end
        end
        E: begin
            next_state = (w == 1'b1) ? D : E;
        end
        F: begin
            next_state = (w == 1'b1) ? D : C;
        end
        default: next_state = A; // Should never reach here
    endcase
end

endmodule