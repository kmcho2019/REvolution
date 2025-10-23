module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // FSM states
    localparam IDLE       = 2'd0;
    localparam RECEIVE    = 2'd1;
    localparam CHECK_STOP = 2'd2;
    localparam WAIT_STOP  = 2'd3;

    reg [1:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // Next-state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (in == 1'b0) // start bit detected
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
                if (in == 1'b1) // valid stop bit
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP; // framing error, wait for stop bit
            end

            WAIT_STOP: begin
                if (in == 1'b1) // wait for line idle (stop bit)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Output logic (Moore output): done asserted only in CHECK_STOP on valid stop bit
    wire done_next = (state == CHECK_STOP) && (in == 1'b1);

    // Sequential logic: state, counters, shift register, done
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;
            done  <= done_next;

            case(next_state)
                IDLE: begin
                    // Reset counters and shift register at start of byte reception cycle
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                WAIT_STOP: begin
                    // Also reset counters and shift register while waiting for stop bit
                    bit_count <= 3'd0;
                    shift_reg <= 8'd0;
                end
                RECEIVE: begin
                    // Shift only in RECEIVE state to reduce toggling
                    // Shift left: insert new bit at LSB (LSB-first)
                    shift_reg <= {shift_reg[6:0], in};
                    bit_count <= bit_count + 1'b1;
                end
                default: begin
                    // Hold bit_count and shift_reg otherwise (CHECK_STOP)
                    // No update needed
                end
            endcase
        end
    end

endmodule