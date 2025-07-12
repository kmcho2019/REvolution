module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// Enum for states
typedef enum logic [2:0] {
    STATE_A,
    STATE_B,
    STATE_C,
    STATE_D,
    STATE_E,
    STATE_F
} state_t;

// Current state and next state
state_t current_state, next_state;

// Counter for x sequence
reg [1:0] x_sequence_counter;

// Counter for y timeout
reg [1:0] y_timeout_counter;

// Temporary signal for f
reg f_temp;

always @(*) begin
    // Default values
    f_temp = 0;
    next_state = current_state;
    x_sequence_counter = x_sequence_counter;
    y_timeout_counter = y_timeout_counter;

    case (current_state)
        STATE_A: begin
            if (~resetn) begin
                next_state = STATE_A;
            end else begin
                next_state = STATE_B;
            end
        end

        STATE_B: begin
            f_temp = 1;
            next_state = STATE_C;
        end

        STATE_C: begin
            case (x_sequence_counter)
                2'b00: begin
                    if (x) begin
                        x_sequence_counter = x_sequence_counter + 1;
                    end
                end
                2'b01: begin
                    if (~x) begin
                        x_sequence_counter = x_sequence_counter + 1;
                    end else begin
                        x_sequence_counter = 2'b00;
                    end
                end
                2'b10: begin
                    if (x) begin
                        next_state = STATE_D;
                        x_sequence_counter = 2'b00;
                    end else begin
                        x_sequence_counter = 2'b00;
                    end
                end
            endcase
        end

        STATE_D: begin
            g = 1;
            if (y || (y_timeout_counter == 2'b11)) begin
                if (y) begin
                    next_state = STATE_E;
                end else begin
                    next_state = STATE_F;
                end
            end else begin
                y_timeout_counter = y_timeout_counter + 1;
            end
        end

        STATE_E: begin
            g = 1;
        end

        STATE_F: begin
            g = 0;
        end
    endcase
end

always @(posedge clk) begin
    if (~resetn) begin
        current_state <= STATE_A;
        x_sequence_counter <= 2'b00;
        y_timeout_counter <= 2'b00;
    end else begin
        current_state <= next_state;
        x_sequence_counter <= x_sequence_counter;
        y_timeout_counter <= y_timeout_counter;
    end
    f <= f_temp;
end

endmodule