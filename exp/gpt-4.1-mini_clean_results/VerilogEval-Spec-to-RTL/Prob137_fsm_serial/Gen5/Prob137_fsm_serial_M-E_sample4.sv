module TopModule (
    input clk,
    input reset,
    input in,
    output reg done
);

    // State encoding (binary)
    localparam [2:0]
        IDLE          = 3'd0,
        START         = 3'd1,
        DATA          = 3'd2,
        STOP_CHECK    = 3'd3,
        ERROR_RECOVERY= 3'd4;

    reg [2:0] state, next_state;
    reg [2:0] bit_count;      // counts 0 to 7 bits received
    reg [7:0] data_shiftreg;  // shift register for incoming data bits

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START;    // start bit detected
                else
                    next_state = IDLE;     // wait for start bit
            end
            START: begin
                // Move directly to DATA to start capturing data bits on next clock
                next_state = DATA;
            end
            DATA: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;  // after 8 bits, check stop bit
                else
                    next_state = DATA;
            end
            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;         // valid stop bit, go back to IDLE
                else
                    next_state = ERROR_RECOVERY; // invalid stop bit, wait for resync
            end
            ERROR_RECOVERY: begin
                if (in == 1'b1)
                    next_state = IDLE;         // stop bit detected, recovered
                else
                    next_state = ERROR_RECOVERY; // keep waiting for stop bit
            end
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shiftreg <= 8'd0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= 1'b0;  // default done low unless set below

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_shiftreg <= 8'd0;
                end
                START: begin
                    bit_count <= 3'd0;  // reset bit count before data bits
                    data_shiftreg <= 8'd0;
                end
                DATA: begin
                    // Shift in LSB first from input serial stream
                    // Shift right and bring in new bit at MSB for LSB-first capture
                    // But actually, since LSB first, we shift left and input in LSB position
                    // So shift right (toward LSB) loses LSB; better shift left and insert at LSB:
                    // Since LSB first: data_shiftreg = {in, data_shiftreg[7:1]} is MSB first
                    // To capture LSB first, shift left and insert at LSB:
                    // data_shiftreg <= {data_shiftreg[6:0], in};
                    data_shiftreg <= {data_shiftreg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end
                STOP_CHECK: begin
                    if (in == 1'b1) begin
                        done <= 1'b1;  // pulse done on successful stop bit detection
                    end
                end
                ERROR_RECOVERY: begin
                    // Hold until stop bit detected, no other action
                end
            endcase
        end
    end

endmodule