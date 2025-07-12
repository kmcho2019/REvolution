module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State definitions
enum logic [2:0] {
    STATE_A = 3'b000, // Initial state
    STATE_B = 3'b001, // Transition state after reset
    STATE_C = 3'b010, // Monitor x input
    STATE_D = 3'b011, // Monitor y input
    STATE_E = 3'b100, // g permanently set to 1
    STATE_F = 3'b101  // g permanently set to 0
} state, nextState;

// Internal signals
reg [1:0] x_sequence_counter; // Counter for x sequence
reg [1:0] y_timeout_counter; // Counter for y timeout

always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        x_sequence_counter <= 0;
        y_timeout_counter <= 0;
    end else begin
        state <= nextState;
        case (state)
            STATE_A: begin
                f <= 0;
                g <= 0;
            end
            STATE_B: begin
                f <= 1;
                g <= 0;
            end
            STATE_C: begin
                f <= 0;
                g <= 0;
            end
            STATE_D: begin
                f <= 0;
                g <= 1;
            end
            STATE_E: begin
                f <= 0;
                g <= 1;
            end
            STATE_F: begin
                f <= 0;
                g <= 0;
            end
            default: begin
                f <= 0;
                g <= 0;
            end
        endcase
    end
end

always @(*) begin
    case (state)
        STATE_A: begin
            if (!resetn) begin
                nextState = STATE_A;
            end else begin
                nextState = STATE_B;
            end
        end
        STATE_B: begin
            nextState = STATE_C;
        end
        STATE_C: begin
            if (x) begin
                if (x_sequence_counter == 0) begin
                    x_sequence_counter = 1;
                end else if (x_sequence_counter == 1 &&!x) begin
                    x_sequence_counter = 2;
                end else if (x_sequence_counter == 2 && x) begin
                    x_sequence_counter = 0;
                    nextState = STATE_D;
                end else begin
                    x_sequence_counter = 0;
                end
            end else if (x_sequence_counter == 1) begin
                x_sequence_counter = 2;
            end else begin
                x_sequence_counter = 0;
            end
            nextState = STATE_C;
        end
        STATE_D: begin
            if (y) begin
                nextState = STATE_E;
            end else if (y_timeout_counter < 2) begin
                y_timeout_counter = y_timeout_counter + 1;
                nextState = STATE_D;
            end else begin
                nextState = STATE_F;
            end
        end
        STATE_E: begin
            nextState = STATE_E;
        end
        STATE_F: begin
            nextState = STATE_F;
        end
        default: begin
            nextState = STATE_A;
        end
    endcase
end

endmodule