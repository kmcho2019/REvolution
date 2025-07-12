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

    // FSM states as enum for clarity
    typedef enum logic [1:0] {
        IDLE     = 2'b00,
        SHIFT    = 2'b01,
        COUNTING = 2'b10,
        DONE     = 2'b11
    } state_t;

    state_t state, next_state;

    // 4-bit shift register for pattern detection
    reg [3:0] pattern_shift;

    // Counter for SHIFT cycles (0 to 3)
    reg [1:0] shift_count;

    // Synchronous logic combining pattern detection and FSM
    always_ff @(posedge clk) begin
        if (reset) begin
            // Reset state and outputs
            state         <= IDLE;
            pattern_shift <= 4'b0000;
            shift_count   <= 2'd0;
            shift_ena     <= 1'b0;
            counting      <= 1'b0;
            done          <= 1'b0;
        end else begin
            // Shift in new data bit for pattern detection
            pattern_shift <= {pattern_shift[2:0], data};

            // Default outputs (will be overridden below)
            shift_ena <= 1'b0;
            counting  <= 1'b0;
            done      <= 1'b0;

            // FSM sequential update
            case (state)
                IDLE: begin
                    // If pattern "1101" detected, move to SHIFT
                    if (pattern_shift == 4'b1101) begin
                        state       <= SHIFT;
                        shift_count <= 2'd0;
                        shift_ena   <= 1'b1;  // Enable shifting immediately on first SHIFT cycle
                    end else begin
                        state <= IDLE;
                    end
                end

                SHIFT: begin
                    shift_ena <= 1'b1; // Assert shift enable for 4 cycles
                    if (shift_count == 2'd3) begin
                        // After 4 cycles shift done
                        state       <= COUNTING;
                        shift_count <= 2'd0;
                    end else begin
                        shift_count <= shift_count + 1'b1;
                        state       <= SHIFT;
                    end
                end

                COUNTING: begin
                    counting <= 1'b1;
                    if (done_counting) begin
                        state <= DONE;
                    end else begin
                        state <= COUNTING;
                    end
                end

                DONE: begin
                    done <= 1'b1;
                    if (ack) begin
                        state <= IDLE;
                    end else begin
                        state <= DONE;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule