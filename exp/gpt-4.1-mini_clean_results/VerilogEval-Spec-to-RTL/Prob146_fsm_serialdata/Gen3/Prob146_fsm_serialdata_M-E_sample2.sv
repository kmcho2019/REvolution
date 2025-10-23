module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg [7:0]  out_byte,
    output reg        done
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE       = 2'd0,
        RECEIVE    = 2'd1,
        STOP_CHECK = 2'd2
    } state_t;

    state_t state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;      // Counts from 0 to 7 for data bits
    reg       in_d;           // Delayed 'in' for edge detection

    // Synchronous sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_count  <= 3'd0;
            shift_reg  <= 8'd0;
            out_byte   <= 8'd0;
            done       <= 1'b0;
            in_d       <= 1'b1; // idle line assumed high at reset
        end else begin
            in_d <= in;       // store previous input for edge detection
            done <= 1'b0;     // default done low unless set below
            state <= next_state;

            case(state)
                IDLE: begin
                    // Wait for start bit falling edge, no data shifting
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift LSB first: insert new bit at LSB, shift previous left
                    // New bit from 'in'
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP_CHECK: begin
                    if (in == 1'b1) begin
                        // Valid stop bit detected, latch output and pulse done
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                    // else invalid stop bit, discard byte and wait for line idle
                    // no registers updated here beyond done and out_byte if valid
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;

        case(state)
            IDLE: begin
                // Detect falling edge on in for start bit
                if (in_d == 1'b1 && in == 1'b0) begin
                    // Start bit detected
                    next_state = RECEIVE;
                end else begin
                    next_state = IDLE;
                end
            end

            RECEIVE: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP_CHECK;
                end else begin
                    next_state = RECEIVE;
                end
            end

            STOP_CHECK: begin
                if (in == 1'b1) begin
                    // Valid stop bit, after done pulse, return to IDLE
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit, wait for line to return to idle (1)
                    // Remain in STOP_CHECK until idle line
                    next_state = (in == 1'b1) ? IDLE : STOP_CHECK;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule