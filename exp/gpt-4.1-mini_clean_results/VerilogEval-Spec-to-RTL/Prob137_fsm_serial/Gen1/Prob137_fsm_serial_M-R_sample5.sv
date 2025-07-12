module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // State encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;   // counts bits 0..7 for 8 data bits
    reg [7:0] shift_reg;

    // Sequential logic: state, bit_count, shift_reg update
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end

                RECEIVE: begin
                    // Shift right by 1 bit, LSB first arrival means shifting right and placing new bit at MSB
                    // shift_reg[7] <= in, others shift down
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // no register updates except state transition
                    // done is combinational outside
                end

                WAIT_STOP: begin
                    // no register updates except state transition
                end

                default: begin
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0)  // detect start bit
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            RECEIVE: begin
                if (bit_count == 3'd7) // after receiving 8th bit (bits 0 to 7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            CHECK_STOP: begin
                if (in == 1'b1)  // correct stop bit
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            WAIT_STOP: begin
                if (in == 1'b1)  // wait until line goes high (stop bit)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // done: single-cycle pulse asserted synchronously immediately after detecting correct stop bit
    // done is combinational, asserted if state is CHECK_STOP and stop bit == 1
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule