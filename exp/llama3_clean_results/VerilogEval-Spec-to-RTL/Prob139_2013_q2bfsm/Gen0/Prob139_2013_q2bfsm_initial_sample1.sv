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
    A = 3'b000, // Initial state, reset asserted
    B = 3'b001, // Set f to 1 for one clock cycle
    C = 3'b010, // Monitor x for sequence 1, 0, 1
    D = 3'b011, // Set g to 1, monitor y
    E = 3'b100, // g remains 1 permanently
    F = 3'b101  // g remains 0 permanently
} state_t;

state_t current_state, next_state;
reg [1:0] x_sequence_counter; // Counter for x sequence
reg [1:0] y_timeout_counter;  // Timeout counter for y

always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
        f <= 0;
        g <= 0;
        x_sequence_counter <= 0;
        y_timeout_counter <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            A: begin
                f <= 0;
                g <= 0;
            end
            B: begin
                f <= 1;
                g <= 0;
            end
            C: begin
                f <= 0;
                g <= 0;
            end
            D: begin
                f <= 0;
                g <= 1;
            end
            E: begin
                f <= 0;
                g <= 1;
            end
            F: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (current_state)
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
            if (x_sequence_counter == 3) begin
                next_state = D;
                x_sequence_counter = 0;
            end else begin
                next_state = C;
                case (x_sequence_counter)
                    0: if (x) x_sequence_counter = 1; else x_sequence_counter = 0;
                    1: if (!x) x_sequence_counter = 2; else x_sequence_counter = 0;
                    2: if (x) x_sequence_counter = 3; else x_sequence_counter = 0;
                endcase
            end
        end
        D: begin
            if (y || y_timeout_counter == 2) begin
                if (y) next_state = E;
                else next_state = F;
                y_timeout_counter = 0;
            end else begin
                next_state = D;
                y_timeout_counter = y_timeout_counter + 1;
            end
        end
        E, F: begin
            next_state = current_state;
        end
    endcase
end

endmodule