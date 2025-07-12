module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output f,
    output g
);

// Define the states of the FSM
typedef enum logic [2:0] {
    A = 3'b000,  // Initial state
    B = 3'b001,  // Transitional state for f
    C = 3'b010,  // Monitoring state for x
    D = 3'b011,  // Transitional state for g
    E = 3'b100,  // Monitoring state for y
    F = 3'b101,  // Permanent state for g = 1
    G = 3'b110   // Permanent state for g = 0
} state_type;

// Define the current state and the next state
state_type current_state, next_state;

// Internal counters for x sequence and y timeout
logic [1:0] x_counter;
logic [1:0] y_counter;

// Assign the outputs based on the current state
always_comb begin
    f = 0;
    g = 0;
    case (current_state)
        B: f = 1;
        D, E, F: g = 1;
    endcase
end

// Update the current state and counters at the positive edge of the clock
always_ff @(posedge clk) begin
    if (~resetn) begin
        current_state <= A;
        x_counter <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            C: begin
                if (x == 1 && x_counter == 0) begin
                    x_counter <= 1;
                end else if (x == 0 && x_counter == 1) begin
                    x_counter <= 2;
                end else if (x == 1 && x_counter == 2) begin
                    x_counter <= 0;
                end else begin
                    x_counter <= 0;
                end
            end
            E: y_counter <= y_counter + 1;
        endcase
    end
end

// Determine the next state
always_comb begin
    next_state = current_state;
    case (current_state)
        A: if (resetn) begin
            next_state = B;
        end
        B: next_state = C;
        C: if (x_counter == 0 && x == 1) begin
            next_state = C;
        end else if (x_counter == 2) begin
            next_state = D;
        end
        D: next_state = E;
        E: if (y) begin
            next_state = F;
        end else if (y_counter == 2) begin
            next_state = G;
        end
        F, G: next_state = current_state;  // Stay in permanent states
    endcase
end

endmodule