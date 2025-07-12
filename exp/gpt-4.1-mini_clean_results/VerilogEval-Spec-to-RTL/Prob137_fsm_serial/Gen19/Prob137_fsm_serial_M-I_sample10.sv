module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire in,
    output reg  done
);

    // One-hot FSM state encoding for potentially faster synthesis and simpler decoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam WAIT_STOP  = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    wire receive_en = (state == RECEIVE);

    // Combinational next state logic
    always @(*) begin
        case (1'b1) // one-hot style decoding
            state[0]: begin // IDLE
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end

            state[1]: begin // RECEIVE
                if (bit_count == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE;
            end

            state[2]: begin // CHECK_STOP
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            state[3]: begin // WAIT_STOP
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_STOP;
            end

            default: next_state = IDLE;
        endcase
    end

    // Sequential logic: state update and registers with clock enable
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
        end else begin
            state <= next_state;

            // Default done low
            done <= 1'b0;

            // bit_count update only in RECEIVE state
            if (receive_en)
                bit_count <= bit_count + 1'b1;
            else if ((state == IDLE) || (state == WAIT_STOP))
                bit_count <= 3'd0;

            // shift_reg update only in RECEIVE state
            if (receive_en)
                shift_reg <= {shift_reg[6:0], in};

            // Generate done pulse when stop bit is valid in CHECK_STOP state
            if (state == CHECK_STOP && in == 1'b1)
                done <= 1'b1;
        end
    end

endmodule