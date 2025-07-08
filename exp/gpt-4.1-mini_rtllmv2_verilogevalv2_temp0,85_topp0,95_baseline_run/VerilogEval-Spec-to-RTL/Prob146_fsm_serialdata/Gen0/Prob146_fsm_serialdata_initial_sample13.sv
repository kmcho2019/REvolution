module TopModule (
    input        clk,
    input        in,
    input        reset,
    output reg [7:0] out_byte,
    output reg       done
);

    // State encoding
    typedef enum reg [1:0] {
        IDLE  = 2'b00,
        START = 2'b01,
        DATA  = 2'b10,
        STOP  = 2'b11
    } state_t;

    state_t state, next_state;

    reg [3:0] bit_count;    // To count data bits received (0 to 7)
    reg [7:0] data_reg;     // To shift in data bits

    // Sequential state and counters update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 0;
            data_reg <= 8'b0;
            out_byte <= 8'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // Default done low, asserted only in STOP on correct stop bit

            case (state)
                IDLE: begin
                    bit_count <= 0;
                    data_reg <= 8'b0;
                end

                START: begin
                    bit_count <= 0;
                    data_reg <= 8'b0;
                end

                DATA: begin
                    // Shift in data bits LSB first
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1;
                end

                STOP: begin
                    // nothing here, done and out_byte handled below
                end
            endcase

            // Handle done and out_byte in STOP state with valid stop bit
            if (state == STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= data_reg;
            end
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = START;
                else
                    next_state = IDLE;
            end

            START: begin
                // After start bit detected, move to DATA immediately next cycle
                next_state = DATA;
            end

            DATA: begin
                if (bit_count == 7) begin
                    // After receiving 8 bits, move to STOP to check stop bit
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end

            STOP: begin
                if (in == 1'b1) begin
                    // Valid stop bit, go to IDLE for next byte
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit, stay in STOP until stop bit found
                    next_state = STOP;
                end
            end

            default: next_state = IDLE;
        endcase
    end

endmodule