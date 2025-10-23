module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // One-hot encoded states for clarity
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;

    reg [7:0] shift_reg;    // shift register for data bits
    reg [2:0] bit_count;    // count of bits received 0..7

    // done output is combinational: asserted when in CHECK_STOP with correct stop bit
    assign done = (state == CHECK_STOP) && (in == 1'b1);

    // Combinational next-state logic
    always @(*) begin
        next_state = state;  // default hold

        case(state)
            IDLE: begin
                if (in == 1'b0)      // start bit detected
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)      // valid stop bit
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

    // Sequential state and data registers update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift in bits LSB first:
                    // shift left by 1, incoming bit to LSB
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    // After checking stop bit, reset counters and shift register for next frame
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                WAIT_STOP: begin
                    // Keep clearing counters waiting for valid stop bit
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

endmodule