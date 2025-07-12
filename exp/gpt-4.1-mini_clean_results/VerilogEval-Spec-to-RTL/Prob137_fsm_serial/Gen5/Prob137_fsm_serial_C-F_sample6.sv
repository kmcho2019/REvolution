module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot FSM states
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Sequential logic: state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done to zero each cycle, pulse in CHECK_STOP if correct stop bit
            done <= 1'b0;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right: insert new bit at LSB (LSB first)
                    // shift_reg <= {shift_reg[7:1], in};  // shift left approach would be MSB first (wrong)
                    shift_reg <= {in, shift_reg[7:1]}; // Shift right, new bit at MSB? This matches Example1 which does {in, reg[7:1]} 
                    // But we want LSB first so new bit at LSB, shift right = {in, reg[7:1]} means new bit is MSB side
                    // Actually Example1 used shift_reg <= {shift_reg[6:0], in};
                    // Correct LSB first means shift left by 1 bit and insert new bit at LSB:
                    // shift_reg <= {shift_reg[6:0], in};
                    // Let's fix that:
                    shift_reg <= {shift_reg[6:0], in};  // Shift left by 1, new bit at LSB; this is correct LSB first

                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    // Assert done for one cycle if stop bit is 1 (correct)
                    if (in == 1'b1)
                        done <= 1'b1;

                    bit_count <= 3'd0; // Reset bit_count regardless
                end

                WAIT_STOP: begin
                    // Wait for stop bit (in == 1)
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

    // Combinational next_state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // Start bit detected
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP; // After 8 bits, check stop bit
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Correct stop bit: back to idle
                else
                    next_state = WAIT_STOP; // Framing error: wait for stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;      // Stop bit detected: resume idle
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule