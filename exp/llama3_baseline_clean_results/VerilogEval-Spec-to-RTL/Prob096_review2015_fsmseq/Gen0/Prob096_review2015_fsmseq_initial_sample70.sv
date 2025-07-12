module TopModule(
    input       clk,
    input       reset,
    input       data,
    output      start_shifting
);

// Enum for states
typedef enum logic [2:0] {
    Idle       = 3'b000,
    Seen1      = 3'b001,
    Seen11     = 3'b010,
    Seen110    = 3'b011,
    SequenceFound = 3'b100
} state_t;

// Current state and next state
state_t current_state, next_state;

// Output logic
assign start_shifting = (current_state == SequenceFound);

// State machine
always_comb begin
    case (current_state)
        Idle: begin
            if (data)
                next_state = Seen1;
            else
                next_state = Idle;
        end
        Seen1: begin
            if (data)
                next_state = Seen11;
            else
                next_state = Idle;
        end
        Seen11: begin
            if (data)
                next_state = Seen11;
            else
                next_state = Seen110;
        end
        Seen110: begin
            if (data)
                next_state = Seen1;
            else
                next_state = SequenceFound;
        end
        SequenceFound: begin
            next_state = SequenceFound;
        end
        default:
            next_state = Idle;
    endcase
end

// State register
always_ff @(posedge clk) begin
    if (reset) begin
        current_state <= Idle;
    end else begin
        current_state <= next_state;
    end
end

endmodule