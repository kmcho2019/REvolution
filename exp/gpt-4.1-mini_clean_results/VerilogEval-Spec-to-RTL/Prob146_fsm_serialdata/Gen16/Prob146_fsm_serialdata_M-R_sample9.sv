module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    typedef enum logic [1:0] {
        IDLE       = 2'd0,
        READ_BITS  = 2'd1,
        CHECK_STOP = 2'd2,
        RECOVER    = 2'd3
    } state_t;

    state_t state, next_state;
    reg [2:0] bit_cnt, next_bit_cnt;
    reg [7:0] shift_reg, next_shift_reg;

    // Next state and output logic
    always @* begin
        // Default assignments
        next_state = state;
        next_bit_cnt = bit_cnt;
        next_shift_reg = shift_reg;
        done = 1'b0;
        out_byte = out_byte; // hold by default

        case (state)
            IDLE: begin
                if (in == 1'b0) begin // start bit detected
                    next_state = READ_BITS;
                    next_bit_cnt = 3'd0;
                    next_shift_reg = 8'd0;
                end
            end

            READ_BITS: begin
                // Shift in LSB first: shift left, put in LSB
                next_shift_reg = {in, shift_reg[7:1]};
                next_bit_cnt = bit_cnt + 1'b1;
                if (bit_cnt == 3'd7) begin
                    next_state = CHECK_STOP;
                end
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    // Valid stop bit
                    done = 1'b1;
                    out_byte = shift_reg;
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit: enter recovery
                    next_state = RECOVER;
                end
            end

            RECOVER: begin
                if (in == 1'b1) begin
                    next_state = IDLE;
                end
            end
        endcase
    end

    // State register update
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_cnt <= 3'd0;
            shift_reg <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            bit_cnt <= next_bit_cnt;
            shift_reg <= next_shift_reg;
            // out_byte and done are updated combinationally in next-state logic
        end
    end

endmodule