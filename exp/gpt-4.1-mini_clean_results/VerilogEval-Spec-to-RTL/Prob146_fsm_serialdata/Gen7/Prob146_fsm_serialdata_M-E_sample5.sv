module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding (5 states)
    localparam IDLE      = 5'b00001;
    localparam START_DET = 5'b00010;  // detect falling edge start bit
    localparam RECEIVE   = 5'b00100;
    localparam STOP      = 5'b01000;
    localparam WAIT_STOP = 5'b10000;

    reg [4:0] state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Synchronize input and create a delayed version to detect falling edge
    reg in_d1;
    always @(posedge clk) begin
        if (reset)
            in_d1 <= 1'b1;
        else
            in_d1 <= in;
    end

    wire start_bit_falling_edge = (in_d1 == 1'b1) && (in == 1'b0);

    // FSM sequential state update
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit counter increments in RECEIVE state, reset elsewhere
    always @(posedge clk) begin
        if (reset)
            bit_count <= 3'd0;
        else if (state == RECEIVE)
            bit_count <= bit_count + 3'd1;
        else
            bit_count <= 3'd0;
    end

    // Shift register updates LSB first on RECEIVE state only
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVE) begin
            // Shift left by 1 and insert new bit at LSB
            // Since LSB first, incoming bit goes to shift_reg[0], so shift right and insert MSB
            // Alternatively, shift right to move bits to MSB side, insert new bit at MSB
            // But problem states LSB first, so incoming bit goes to LSB.
            // Thus shift right, insert new bit at MSB side is not correct.
            // Correct: shift right by 1, insert new bit at MSB == MSB first
            // For LSB first, shift left by 1, insert new bit at LSB.
            shift_reg <= {in, shift_reg[7:1]};
        end else if (state == START_DET)
            shift_reg <= 8'd0; // Clear shift reg on start detection
    end

    // Output logic and done signal
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default no done pulse
            if (state == STOP) begin
                if (in == 1'b1) begin
                    // Valid stop bit: output byte and pulse done
                    out_byte <= shift_reg;
                    done <= 1'b1;
                end
            end
        end
    end

    // Next state logic: one-hot encoding
    always @(*) begin
        // Default next state is current to avoid latches
        next_state = state;

        case (state)
            IDLE: begin
                // Wait for falling edge start bit
                if (start_bit_falling_edge)
                    next_state = START_DET;
                else
                    next_state = IDLE;
            end

            START_DET: begin
                // Confirm start bit held low (line stable low) next cycle before reception
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE; // noise or glitch, go back to idle
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP; // after receiving 8 bits
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE; // valid stop bit, back to idle for next byte
                else
                    next_state = WAIT_STOP; // invalid stop, wait until line idle
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule