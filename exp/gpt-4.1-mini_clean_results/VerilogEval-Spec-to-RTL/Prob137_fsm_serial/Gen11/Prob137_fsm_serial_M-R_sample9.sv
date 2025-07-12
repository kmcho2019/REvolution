module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // State encoding
    localparam IDLE       = 2'b00;
    localparam RECEIVE    = 2'b01;
    localparam CHECK_STOP = 2'b10;
    localparam WAIT_STOP  = 2'b11;

    reg [1:0] state, next_state;
    reg [7:0] shift_reg;
    reg [2:0] bit_count;

    // Next state combinational logic
    always @(*) begin
        case(state)
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

    // Sequential block: update state, shift register, bit counter
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            shift_reg <= 8'd0;
            bit_count <= 3'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end

                RECEIVE: begin
                    // LSB-first: shift left, serial in bit into bit 0
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1;
                end

                CHECK_STOP: begin
                    // reset bit_count and shift_reg for next byte reception
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end

                WAIT_STOP: begin
                    shift_reg <= 8'd0;
                    bit_count <= 3'd0;
                end
            endcase

            // done pulse generation: only in CHECK_STOP with valid stop bit
            done <= (state == CHECK_STOP) && (in == 1'b1);
        end
    end

endmodule