module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Define states
typedef enum logic [2:0] {
    A = 3'b000, // Initial state
    B = 3'b001, // Transient state after reset
    C = 3'b010, // Monitoring state for x
    D = 3'b011, // Monitoring state for y
    E = 3'b100  // Final state for g
} state_t;

// Current state and next state
state_t current_state, next_state;

// Flags and counters
reg [1:0] x_sequence; // To track x sequence 1, 0, 1
reg [1:0] y_counter;  // To count cycles until y becomes 1

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        x_sequence <= 0;
        y_counter <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            A: begin
                if (!resetn) begin
                    f <= 0;
                    g <= 0;
                end else begin
                    next_state <= B;
                    f <= 1;
                    g <= 0;
                end
            end
            B: begin
                next_state <= C;
                f <= 0;
                g <= 0;
            end
            C: begin
                if (x) begin
                    x_sequence <= {x_sequence[0], 1};
                end else begin
                    x_sequence <= {x_sequence[0], 0};
                end
                if (x_sequence == 2'b101) begin
                    next_state <= D;
                    g <= 1;
                end else begin
                    next_state <= C;
                    g <= 0;
                end
                f <= 0;
            end
            D: begin
                next_state <= E;
                y_counter <= y_counter + 1;
                if (y) begin
                    y_counter <= 2; // Force to maximum to ensure g stays 1
                end
                f <= 0;
            end
            E: begin
                if (y_counter < 2 && y) begin
                    y_counter <= 2; // Stay in this state with g=1
                end else if (y_counter == 2 && !y) begin
                    g <= 0; // If y didn't become 1 within 2 cycles, set g to 0
                end
                next_state <= E;
                f <= 0;
            end
            default: begin
                next_state <= A;
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

endmodule