module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding: 2 bits for 4 states
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam STOP_CHECK = 2'd2;
    localparam RECOVER    = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Enable signal for counting and shifting bits
    wire shift_en = (state == RECEIVE);

    // Sequential logic: state, bit counter, shift register, done, out_byte
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;
            done  <= 1'b0;  // default, pulse done only on valid stop bit

            if (shift_en) begin
                // Shift left by 1, new bit goes to bit 0 (LSB first)
                shift_reg <= {shift_reg[6:0], in};
                bit_cnt   <= bit_cnt + 3'd1;
            end else begin
                bit_cnt <= 3'd0;
                if (state == IDLE)
                    shift_reg <= 8'd0;
            end

            if (state == STOP_CHECK) begin
                if (in == 1'b1) begin
                    // Valid stop bit: output received byte and pulse done
                    out_byte <= shift_reg;
                    done     <= 1'b1;
                end
            end
        end
    end

    // Next state combinational logic with explicit priority and clarity
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                // After 8 bits received, go to stop check
                if (bit_cnt == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end

            STOP_CHECK: begin
                // Check stop bit correctness
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;  // Wait for line to return to idle
            end

            RECOVER: begin
                // Wait for idle line (stop bit or line high)
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule