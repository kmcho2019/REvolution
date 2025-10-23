module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output wire done
);

    // One-hot encoded FSM states
    localparam [3:0]
        IDLE       = 4'b0001,
        RECEIVE    = 4'b0010,
        CHECK_STOP = 4'b0100,
        WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
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
                if (in == 1'b1)
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

    // Sequential logic: state, bit_count, shift_reg
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
                    // Shift left: incoming bit shifted into LSB
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end

                CHECK_STOP: begin
                    // bit_count reset here to prepare for next byte reception
                    bit_count <= 3'd0;
                end

                WAIT_STOP: begin
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

    // done signal: high for one cycle when stop bit correct detected
    // done is asserted when state is CHECK_STOP and input bit == 1
    assign done = (state == CHECK_STOP) && (in == 1'b1);

endmodule