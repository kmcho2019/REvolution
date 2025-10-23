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
        WAIT       // Waiting for valid stop bit
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
            
            // Clock gating for power optimization
            if (state == RECEIVE) begin
                data_reg <= {in, data_reg[7:1]};  // LSB first
                bit_count <= bit_count + 1;
            end
            else if (state == IDLE) begin
                bit_count <= 0;
            end

            // Only update done_reg in STOP state
            if (state == STOP) begin
                done_reg <= in;
            end else begin
                done_reg <= 0;
            end
        end
    end

    // Next state logic - optimized for timing
    always @(*) begin
        case (state)
            IDLE:    next_state = (~in) ? RECEIVE : IDLE;
            RECEIVE: next_state = (&bit_count) ? STOP : RECEIVE;  // bit_count == 3'b111
            STOP:    next_state = in ? IDLE : WAIT;
            WAIT:    next_state = in ? IDLE : WAIT;
            default: next_state = IDLE;
        endcase
    end

    assign done = done_reg;

endmodule