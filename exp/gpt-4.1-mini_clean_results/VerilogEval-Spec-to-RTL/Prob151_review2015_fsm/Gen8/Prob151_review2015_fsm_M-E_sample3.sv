module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire data,
    input  wire done_counting,
    input  wire ack,
    output reg  shift_ena,
    output reg  counting,
    output reg  done
);

// State encoding as enumerated type for clarity
typedef enum reg [3:0] {
    IDLE    = 4'd0, // Waiting for first '1' of pattern
    P1      = 4'd1, // Matched '1'
    P11     = 4'd2, // Matched '11'
    P110    = 4'd3, // Matched '110'
    P1101   = 4'd4, // Matched '1101' (pattern fully detected)
    SHIFT   = 4'd5, // Shifting in 4 bits
    COUNT   = 4'd6, // Waiting for counting done
    DONE    = 4'd7  // Timer done, waiting for ack
} state_t;

state_t state, next_state;

// 2-bit counter for counting the 4 shift cycles (0 to 3)
reg [1:0] shift_count;

// Synchronous state and counter update
always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        shift_count <= 2'd0;
    end else begin
        state <= next_state;

        // Increment shift_count only in SHIFT state
        if (state == SHIFT)
            shift_count <= shift_count + 2'd1;
        else
            shift_count <= 2'd0;
    end
end

// Next state logic
always @(*) begin
    next_state = state; // default hold

    case (state)
        IDLE: begin
            if (data == 1'b1)
                next_state = P1;
            else
                next_state = IDLE;
        end
        P1: begin
            if (data == 1'b1)
                next_state = P11;
            else
                next_state = IDLE;
        end
        P11: begin
            if (data == 1'b0)
                next_state = P110;
            else if (data == 1'b1)
                next_state = P11; // Repeated '1' stays here to handle overlaps
            else
                next_state = IDLE;
        end
        P110: begin
            if (data == 1'b1)
                next_state = SHIFT; // Pattern detected: 1101
            else if (data == 1'b0)
                next_state = IDLE; // Fail pattern, restart search
            else
                next_state = IDLE;
        end
        SHIFT: begin
            if (shift_count == 2'd3)
                next_state = COUNT;
            else
                next_state = SHIFT;
        end
        COUNT: begin
            if (done_counting)
                next_state = DONE;
            else
                next_state = COUNT;
        end
        DONE: begin
            if (ack)
                next_state = IDLE;
            else
                next_state = DONE;
        end
        default: next_state = IDLE;
    endcase
end

// Output logic synchronous to state
always @(posedge clk) begin
    if (reset) begin
        shift_ena <= 1'b0;
        counting  <= 1'b0;
        done      <= 1'b0;
    end else begin
        // Default outputs off
        shift_ena <= 1'b0;
        counting  <= 1'b0;
        done      <= 1'b0;

        case (state)
            SHIFT:   shift_ena <= 1'b1;
            COUNT:   counting  <= 1'b1;
            DONE:    done      <= 1'b1;
            default: ;
        endcase
    end
end

endmodule