module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // Binary encoded FSM states
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam STOP       = 2'b10;
    localparam ERROR_WAIT = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Next state logic (combinational)
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
                // After receiving 8 bits (bit_cnt == 7), go to STOP
                if (bit_cnt == 3'd7)
                    next_state = STOP;
                else
                    next_state = RECEIVE;
            end

            STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Valid stop bit
                else
                    next_state = ERROR_WAIT; // Invalid stop bit
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Wait until line idle
                else
                    next_state = ERROR_WAIT;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, counters, shift register, outputs
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;
            done  <= 1'b0; // Default deassert done

            case (state)
                IDLE: begin
                    bit_cnt   <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in new bit at LSB side
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt   <= bit_cnt + 3'd1;
                end

                STOP: begin
                    // Check stop bit validity
                    if (in == 1'b1) begin
                        done     <= 1'b1;
                        out_byte <= shift_reg;
                    end
                end

                ERROR_WAIT: begin
                    // Hold values, wait for idle line
                end
            endcase
        end
    end

endmodule