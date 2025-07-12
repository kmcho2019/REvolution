module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define states as an enum
typedef enum logic [2:0] {
    A = 3'b000,  // Initial state
    B = 3'b001,  // Set f = 1 for one cycle
    C = 3'b010,  // Monitor x for 1, 0, 1
    D = 3'b011,  // Set g = 1, monitor y
    E = 3'b100,  // Maintain g = 1
    F = 3'b101   // Maintain g = 0
} state_t;

state_t current_state, next_state;

// Sequential logic for state transitions
always_ff @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
    end else begin
        current_state <= next_state;
        if (next_state == B) begin
            f <= 1;
        end else begin
            f <= 0;
        end
        if (next_state == E) begin
            g <= 1;
        end else if (next_state == F) begin
            g <= 0;
        end
    end
end

// Combinational logic for next state and output logic
always_comb begin
    case(current_state)
        A: begin
            if (resetn) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            next_state = C;
        end
        C: begin
            static logic [1:0] x_sequence = 2'b00;
            x_sequence = {x_sequence[0], x};
            if (x_sequence == 2'b101) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        D: begin
            static logic [1:0] y_count = 2'b00;
            if (y) begin
                next_state = E;
            end else begin
                y_count = y_count + 1;
                if (y_count == 2) begin
                    next_state = F;
                end else begin
                    next_state = D;
                end
            end
        end
        E, F: begin
            next_state = current_state; // Stay in the same state
        end
        default: next_state = A;
    endcase
end

endmodule