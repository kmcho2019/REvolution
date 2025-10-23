module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding
    localparam IDLE      = 2'd0;
    localparam RECEIVE   = 2'd1;
    localparam STOP_WAIT = 2'd2;
    localparam ERROR_WAIT= 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_cnt;      // counts 0 to 7 data bits
    reg [7:0] shift_reg;

    // State and registers update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            out_byte  <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0; // default done low

            case (state)
                IDLE: begin
                    bit_cnt <= 3'd0;
                    if (in == 1'b0) begin // start bit detected
                        // next_state handled combinationally
                    end
                end

                RECEIVE: begin
                    // Shift in LSB-first
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 3'd1;
                end

                STOP_WAIT: begin
                    if (in == 1'b1) begin
                        out_byte <= shift_reg;
                        done <= 1'b1; // pulse done
                    end
                end

                ERROR_WAIT: begin
                    // Waiting for line to return to idle (in==1)
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state; // default hold

        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = RECEIVE; // start bit detected
            end

            RECEIVE: begin
                if (bit_cnt == 3'd7)
                    next_state = STOP_WAIT; // all 8 bits received
            end

            STOP_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE; // valid stop bit, go idle
                else
                    next_state = ERROR_WAIT; // invalid stop bit, wait for idle
            end

            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE; // line idle, resume normal operation
            end
        endcase
    end

endmodule