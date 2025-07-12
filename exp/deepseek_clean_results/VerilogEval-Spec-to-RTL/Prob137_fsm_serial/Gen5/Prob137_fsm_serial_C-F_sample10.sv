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
        ERROR      // Waiting for valid stop bit
    } state_t;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;  // Counts 0-7 (3 bits)
    reg [7:0] data_reg;
    reg done_reg;

    // State transition and data sampling
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 0;
            done_reg <= 0;
        end else begin
            state <= next_state;
            
            // Default assignments
            done_reg <= 0;
            
            case (state)
                IDLE: begin
                    bit_count <= 0;
                end

                RECEIVE: begin
                    data_reg <= {in, data_reg[7:1]};  // LSB first
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    done_reg <= in;  // Set done if stop bit is valid (1)
                end

                ERROR: begin
                    // No operations needed, just waiting
                end
            endcase
        end
    end

    // Next state logic - optimized for clarity and timing
    always @(*) begin
        case (state)
            IDLE:    next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE: next_state = (bit_count == 3'b111) ? STOP : RECEIVE;
            STOP:    next_state = in ? IDLE : ERROR;
            ERROR:   next_state = in ? IDLE : ERROR;
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule