module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states encoded as 2-bit binary
    localparam IDLE    = 2'b00,
               RECEIVE = 2'b01,
               STOP    = 2'b10;

    reg [1:0] state, next_state;
    reg [7:0] data_reg;
    reg [2:0] bit_count; // 0 to 7 bits
    reg error_stop;

    always @(*) begin
        done = 1'b0;
        next_state = state;

        case (state)
            IDLE: begin
                if (in == 1'b0) // Start bit detected
                    next_state = RECEIVE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP;
            end

            STOP: begin
                if (in == 1'b1 && !error_stop) begin
                    done = 1'b1;  // valid stop bit, done pulse
                    next_state = IDLE;
                end else if (in == 1'b1 && error_stop) begin
                    // Stop bit detected after error, clear error and go idle
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit, stay in STOP state waiting for stop bit
                    next_state = STOP;
                    // error_stop stays set
                end
            end
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            data_reg <= 8'd0;
            error_stop <= 1'b0;
            done <= 1'b0;
        end else begin
            state <= next_state;
            done <= done; // updated combinationally above

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    data_reg <= 8'd0;
                    error_stop <= 1'b0;
                end

                RECEIVE: begin
                    // Shift in LSB first (new bit into LSB)
                    data_reg <= {in, data_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                STOP: begin
                    if (in != 1'b1) 
                        error_stop <= 1'b1;
                    else if (error_stop)
                        error_stop <= 1'b0;
                    // bit_count and data_reg hold until IDLE reset
                end
            endcase
        end
    end

endmodule