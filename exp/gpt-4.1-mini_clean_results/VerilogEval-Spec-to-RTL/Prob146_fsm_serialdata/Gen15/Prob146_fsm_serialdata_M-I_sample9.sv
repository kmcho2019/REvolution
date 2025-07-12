module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot FSM state encoding (4 states)
    localparam IDLE_BIT      = 4'b0001,
               RECEIVE_BIT   = 4'b0010,
               STOP_BIT      = 4'b0100,
               ERROR_WAIT_BIT= 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    wire receive_en = state[1]; // RECEIVE state enable

    // FSM state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE_BIT;
        else
            state <= next_state;
    end

    // Bit counter: enable increment only in RECEIVE; reset otherwise
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (receive_en)
            bit_cnt <= bit_cnt + 3'd1;
        else
            bit_cnt <= 3'd0;
    end

    // Shift register: shift right and load new bit in MSB only in RECEIVE, hold otherwise
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (receive_en)
            shift_reg <= {in, shift_reg[7:1]};
        else
            shift_reg <= shift_reg; // hold to reduce toggling
    end

    // done and out_byte update
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0; // default no pulse
            // Assert done in STOP state only if stop bit is valid (in == 1)
            if (state[2] && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

    // Next state combinational logic
    always @(*) begin
        next_state = 4'b0000; // default no state (should never occur)
        case (1'b1) // one-hot state decode
            state[0]: begin // IDLE
                if (in == 1'b0)
                    next_state = RECEIVE_BIT;
                else
                    next_state = IDLE_BIT;
            end
            state[1]: begin // RECEIVE
                if (bit_cnt == 3'd7)
                    next_state = STOP_BIT;
                else
                    next_state = RECEIVE_BIT;
            end
            state[2]: begin // STOP
                if (in == 1'b1)
                    next_state = IDLE_BIT;
                else
                    next_state = ERROR_WAIT_BIT;
            end
            state[3]: begin // ERROR_WAIT
                if (in == 1'b1)
                    next_state = IDLE_BIT;
                else
                    next_state = ERROR_WAIT_BIT;
            end
            default: next_state = IDLE_BIT;
        endcase
    end

endmodule