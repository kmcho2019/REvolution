module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg done
);

    // Define states
    typedef enum logic [2:0] {
        IDLE      = 3'd0,
        START     = 3'd1,
        DATA      = 3'd2,
        STOP      = 3'd3,
        WAIT_STOP = 3'd4
    } state_t;

    state_t state, next_state;

    reg [2:0] bit_count;  // 0 to 7 for 8 data bits
    reg [7:0] data_shift;

    // Sequential state and registers update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            done <= 1'b0; // default clear done, asserted only one cycle in STOP when valid

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shift <= 8'd0;
                end
                START: begin
                    // no update of bit_count or data_shift here
                end
                DATA: begin
                    // Shift in bit, LSB first
                    data_shift <= {in, data_shift[7:1]};
                    bit_count <= bit_count + 3'd1;
                end
                STOP: begin
                    if (in == 1'b1) begin
                        done <= 1'b1; // valid byte received
                    end
                end
                WAIT_STOP: begin
                    // hold bit_count and data_shift unchanged until stop bit detected
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (in == 1'b0) // detect start bit
                    next_state = START;
            end
            START: begin
                // After detecting start bit, move to data reception
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 3'd7) begin
                    next_state = STOP;
                end else begin
                    next_state = DATA;
                end
            end
            STOP: begin
                if (in == 1'b1) begin
                    // Valid stop bit, go back to IDLE to receive next byte
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit, wait until stop bit appears
                    next_state = WAIT_STOP;
                end
            end
            WAIT_STOP: begin
                if (in == 1'b1) begin
                    // Stop bit received, go back to IDLE
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
            end
            default: next_state = IDLE;
        endcase
    end

endmodule