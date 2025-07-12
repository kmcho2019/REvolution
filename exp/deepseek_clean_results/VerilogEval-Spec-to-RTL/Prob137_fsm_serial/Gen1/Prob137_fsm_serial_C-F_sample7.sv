module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    // Define states with clear names
    typedef enum logic [1:0] {
        IDLE,      // Waiting for start bit
        RECEIVE,   // Receiving 8 data bits
        STOP,      // Checking stop bit
        WAIT       // Waiting for line to return to idle
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;  // Counts 0-7 (3 bits)
    reg [7:0] shift_reg;
    reg done_reg;

    // State transition and data sampling
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            shift_reg <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            done_reg <= 0;  // Default to 0, set only in STOP state

            case (state)
                IDLE: begin
                    bit_count <= 0;
                end

                RECEIVE: begin
                    shift_reg <= {in, shift_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    done_reg <= in;  // Set done if stop bit is valid (1)
                end

                WAIT: begin
                    // No operations needed, just waiting
                end
            endcase
        end
    end

    // Next state logic - optimized for clarity and timing
    always @(*) begin
        next_state = state;  // Default to current state
        
        case (state)
            IDLE: begin
                if (!in) next_state = RECEIVE;  // Start bit detected
            end

            RECEIVE: begin
                if (bit_count == 3'b111) next_state = STOP;  // All bits received
            end

            STOP: begin
                next_state = in ? IDLE : WAIT;  // Valid stop bit or error
            end

            WAIT: begin
                if (in) next_state = IDLE;  // Line returned to idle
            end
        endcase
    end

    assign done = done_reg;

endmodule