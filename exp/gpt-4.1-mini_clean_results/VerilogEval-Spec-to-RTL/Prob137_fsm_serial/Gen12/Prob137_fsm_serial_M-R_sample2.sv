module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // One-hot state encoding
    localparam [3:0]
        IDLE       = 4'b0001,
        RECEIVE    = 4'b0010,
        CHECK_STOP = 4'b0100,
        WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count, next_bit_count;
    reg [7:0] shift_reg, next_shift_reg;

    // Combinational logic for next state and data registers
    always @(*) begin
        // Defaults: hold current values
        next_state = state;
        next_bit_count = bit_count;
        next_shift_reg = shift_reg;

        case (state)
            IDLE: begin
                if (in == 1'b0) begin
                    // Detected start bit -> go to RECEIVE
                    next_state = RECEIVE;
                    next_bit_count = 3'd0;
                    next_shift_reg = 8'd0;
                end else begin
                    next_state = IDLE;
                end
            end

            RECEIVE: begin
                // Shift in bit at LSB, shift right to receive LSB first
                next_shift_reg = {in, shift_reg[7:1]};
                if (bit_count == 3'd7) begin
                    next_state = CHECK_STOP;
                    next_bit_count = 3'd0;
                end else begin
                    next_bit_count = bit_count + 1;
                    next_state = RECEIVE;
                end
            end

            CHECK_STOP: begin
                if (in == 1'b1) begin
                    // Stop bit correct, go back to IDLE
                    next_state = IDLE;
                end else begin
                    // Invalid stop bit, wait for stop bit
                    next_state = WAIT_STOP;
                end
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
            end

            WAIT_STOP: begin
                if (in == 1'b1) begin
                    // Stop bit detected, back to IDLE
                    next_state = IDLE;
                end else begin
                    next_state = WAIT_STOP;
                end
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
            end

            default: begin
                next_state = IDLE;
                next_bit_count = 3'd0;
                next_shift_reg = 8'd0;
            end
        endcase
    end

    // Synchronous update of state and registers
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;
            bit_count <= next_bit_count;
            shift_reg <= next_shift_reg;
        end
    end

    // done is high when in CHECK_STOP state and stop bit is correct (in == 1)
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule