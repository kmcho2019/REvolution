module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // States for FSM
    typedef enum reg [1:0] {
        IDLE        = 2'd0,
        RECEIVE     = 2'd1,
        ERROR_WAIT  = 2'd2
    } state_t;

    state_t state, next_state;

    reg [3:0] bit_idx;      // 0=start bit, 1-8=data bits, 9=stop bit
    reg [7:0] data_shift;   // shift register for data bits

    // Next state logic combinational
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)  // Detect start bit (line goes low)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_idx == 4'd9) begin
                    // After stop bit received, check validity
                    if (in == 1'b1)
                        next_state = IDLE;       // Valid stop bit, go idle
                    else
                        next_state = ERROR_WAIT; // Invalid stop bit, wait for idle line
                end else begin
                    next_state = RECEIVE;
                end
            end
            ERROR_WAIT: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = ERROR_WAIT;
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state, bit_idx, data_shift, done
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_idx <= 4'd0;
            data_shift <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // Default de-assert done

            case (state)
                IDLE: begin
                    bit_idx <= 4'd0;
                    data_shift <= 8'd0;
                end
                RECEIVE: begin
                    bit_idx <= bit_idx + 1'b1;
                    if (bit_idx >= 4'd1 && bit_idx <= 4'd8) begin
                        // Shift in data bits LSB first: shift left, insert new bit at LSB
                        data_shift <= {in, data_shift[7:1]};
                    end
                    if (bit_idx == 4'd9) begin
                        // Stop bit processed this cycle; assert done if valid stop bit (in==1)
                        if (in == 1'b1)
                            done <= 1'b1;
                    end
                end
                ERROR_WAIT: begin
                    bit_idx <= 4'd0;
                    data_shift <= 8'd0;
                end
                default: begin
                    bit_idx <= 4'd0;
                    data_shift <= 8'd0;
                end
            endcase
        end
    end

endmodule