module fsm(
    input logic IN,
    input logic CLK,
    input logic RST,
    output logic MATCH
);

// One-hot encoding for states
typedef enum logic [5:0] {
    IDLE = 6'b000001,
    START = 6'b000010,
    ZERO1 = 6'b000100,
    ZERO2 = 6'b001000,
    ONE1 = 6'b010000,
    ONE2 = 6'b100000
} state_t;

state_t current_state, next_state;

// Directly set MATCH based on the ONE2 state for simplicity
assign MATCH = (current_state == ONE2);

always_comb begin
    case (1'b1) // Using one-hot encoding, only one bit is set at a time
        current_state[0]: begin // IDLE
            if (IN) begin
                next_state = START;
            end else begin
                next_state = IDLE;
            end
        end
        current_state[1]: begin // START
            if (!IN) begin
                next_state = ZERO1;
            end else begin
                next_state = IDLE;
            end
        end
        current_state[2]: begin // ZERO1
            if (!IN) begin
                next_state = ZERO2;
            end else begin
                next_state = IDLE;
            end
        end
        current_state[3]: begin // ZERO2
            if (IN) begin
                next_state = ONE1;
            end else begin
                next_state = IDLE;
            end
        end
        current_state[4]: begin // ONE1
            if (IN) begin
                next_state = ONE2;
            end else begin
                next_state = IDLE;
            end
        end
        current_state[5]: begin // ONE2
            next_state = IDLE;
        end
        default: begin
            next_state = IDLE;
        end
    endcase
end

// Sequential logic for state updates
always_ff @(posedge CLK or posedge RST) begin
    if (RST) begin
        current_state <= IDLE;
    end else begin
        current_state <= next_state;
    end
end

endmodule