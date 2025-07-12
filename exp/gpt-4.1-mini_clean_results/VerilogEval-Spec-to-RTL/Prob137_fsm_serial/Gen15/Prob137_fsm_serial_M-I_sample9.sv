module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot encoded FSM states (4 bits)
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;
    reg shift_en, count_en;

    // Next state logic (combinational)
    always @(*) begin
        next_state = 4'b0000;
        case (1'b1)
            state[0]: begin // IDLE
                if (in == 1'b0)      // Detect start bit (0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            state[1]: begin // RECEIVE
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            state[2]: begin // CHECK_STOP
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            state[3]: begin // WAIT_STOP
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Control signals for shift register and bit counter enable
    always @(*) begin
        // Default disables
        shift_en = 1'b0;
        count_en = 1'b0;

        if (state[1]) begin // RECEIVE state
            shift_en = 1'b1;
            count_en = 1'b1;
        end
    end

    // Sequential logic: state, bit_count, shift_reg, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // default done low

            // Shift register update (only in RECEIVE)
            if (shift_en) begin
                // Shift right, insert new bit at MSB for LSB-first reception:
                // The first received bit ends in LSB of shift_reg after 8 shifts
                shift_reg <= {in, shift_reg[7:1]};
            end

            // Bit counter increment
            if (count_en)
                bit_count <= bit_count + 1'b1;
            else
                bit_count <= 3'd0;

            // IDLE and WAIT_STOP reset registers to reduce toggling
            if (state[0] || state[3]) begin
                bit_count <= 3'd0;
                shift_reg <= 8'd0;
            end

            // done pulse generation at CHECK_STOP if stop bit correct
            if (state[2] && (in == 1'b1))
                done <= 1'b1;
        end
    end

endmodule