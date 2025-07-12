module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // Define FSM states with typedef enum for clarity and tool optimization
    typedef enum logic [1:0] {
        IDLE       = 2'b00, // Waiting for start bit (0)
        RECEIVE    = 2'b01, // Receiving 8 data bits (LSB first)
        CHECK_STOP = 2'b10, // Checking stop bit (should be 1)
        WAIT_STOP  = 2'b11  // Waiting for a valid stop bit after error
    } state_t;

    state_t state, next_state;

    reg [7:0] shift_reg;   // Data register to hold received byte
    reg [2:0] bit_count;   // Counts bits received (0 to 7)

    reg done_next;         // Combinational done signal before registering

    // Combinational logic: next state and done generation
    always @(*) begin
        next_state = state;
        done_next = 1'b0;

        case (state)
            IDLE: begin
                if (in == 1'b0)     // Detect start bit
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    done_next = 1'b1;    // Valid stop bit: pulse done
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP; // Invalid stop bit: wait for a correct one
                end
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: begin
                next_state = IDLE;
                done_next = 1'b0;
            end
        endcase
    end

    // Sequential logic: state, shift register, bit counter, and done update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done_next;

            case (state)
                IDLE: begin
                    // Clear registers when idle to reduce unnecessary toggling
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in LSB first: shift right, insert new bit into MSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // Clear counters and shift reg after checking stop bit for next byte
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                WAIT_STOP: begin
                    // Hold cleared counters and shift reg waiting for valid stop bit
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule