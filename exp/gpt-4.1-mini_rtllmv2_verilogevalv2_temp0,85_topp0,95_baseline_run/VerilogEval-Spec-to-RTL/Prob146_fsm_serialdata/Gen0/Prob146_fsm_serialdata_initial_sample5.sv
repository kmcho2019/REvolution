module TopModule (
    input clk,
    input in,
    input reset,
    output reg [7:0] out_byte,
    output reg done
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE    = 2'b00,
        RECEIVE = 2'b01,
        STOP    = 2'b10
    } state_t;

    reg [2:0] bit_count;    // count bits received (0 to 7)
    reg [7:0] data_shift;   // shift register for data bits
    reg wait_for_stop;      // flag indicating waiting for valid stop bit after error
    reg [1:0] state, next_state;

    // Sequential logic for state, data, bit_count and done output
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_shift <= 8'd0;
            out_byte <= 8'd0;
            done <= 1'b0;
            wait_for_stop <= 1'b0;
        end else begin
            done <= 1'b0; // default

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    if (in == 1'b0) begin // start bit detected
                        state <= RECEIVE;
                    end
                end

                RECEIVE: begin
                    data_shift <= {in, data_shift[7:1]}; // shift in LSB first (in is LSB)
                    bit_count <= bit_count + 1'b1;
                    if (bit_count == 3'd7) begin
                        state <= STOP;
                    end
                end

                STOP: begin
                    if (in == 1'b1) begin
                        // correct stop bit
                        out_byte <= data_shift;
                        done <= 1'b1;
                        state <= IDLE;
                        wait_for_stop <= 1'b0;
                    end else begin
                        // invalid stop bit, stay here until stop bit received
                        wait_for_stop <= 1'b1;
                    end
                end
            endcase

            // If we are waiting for a correct stop bit after error
            if (wait_for_stop) begin
                if (in == 1'b1) begin
                    // stop bit received, now go to IDLE to await next start bit
                    state <= IDLE;
                    wait_for_stop <= 1'b0;
                end
                // else remain in wait_for_stop with state STOP
            end
        end
    end

endmodule