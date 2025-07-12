module TopModule (
    input  wire clk,
    input  wire in,
    input  wire reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding using localparams for better synthesis compatibility
    localparam IDLE      = 2'b00;
    localparam DATA      = 2'b01;
    localparam STOP      = 2'b10;
    localparam WAIT_STOP = 2'b11;

    reg [1:0] state, next_state;

    reg [7:0] shift_reg;
    reg [2:0] bit_cnt;

    reg done_pulse;

    // Sequential logic: state, bit counter, shift reg, done pulse
    always @(posedge clk) begin
        if (reset) begin
            state      <= IDLE;
            bit_cnt    <= 3'd0;
            shift_reg  <= 8'd0;
            out_byte   <= 8'd0;
            done_pulse <= 1'b0;
            done       <= 1'b0;
        end else begin
            state <= next_state;

            // Default done_pulse cleared
            done_pulse <= 1'b0;
            done       <= done_pulse;

            case (state)
                IDLE: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                DATA: begin
                    // Shift LSB first: shift right, new bit in MSB would reverse order,
                    // so shift left and insert incoming bit at LSB
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt   <= bit_cnt + 1'b1;
                end

                STOP: begin
                    bit_cnt <= 3'd0;
                    if (in == 1'b1) begin
                        // Valid stop bit
                        out_byte   <= shift_reg;
                        done_pulse <= 1'b1;
                    end
                    // else: invalid stop bit, handled in next_state
                end

                WAIT_STOP: begin
                    // Wait until stop bit (in == 1) detected, no changes needed
                    bit_cnt <= bit_cnt;
                    shift_reg <= shift_reg;
                end
            endcase
        end
    end

    // Combinational next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0) // Detect start bit
                    next_state = DATA;
                else
                    next_state = IDLE;
            end

            DATA: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = DATA;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
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