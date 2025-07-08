module TopModule(
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        DATA = 2'b01,
        STOP = 2'b10,
        RECOVERY = 2'b11
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;  // counts bits received (0 to 7)
    reg [7:0] shift_reg;

    // Sequential logic: state transition and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;

            // Default done is 0 unless set below
            done <= 1'b0;

            case (state)
                IDLE: begin
                    // waiting for start bit (0)
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // shift in data bits, LSB first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 3'd1;
                end

                STOP: begin
                    // Check stop bit and output byte if valid
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1;
                    end
                end

                RECOVERY: begin
                    // wait for stop bit to be 1 to resync
                end
            endcase
        end
    end

    // Combinational logic: next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVERY;
            end

            RECOVERY: begin
                // Wait for line to be 1 (stop bit)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVERY;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule