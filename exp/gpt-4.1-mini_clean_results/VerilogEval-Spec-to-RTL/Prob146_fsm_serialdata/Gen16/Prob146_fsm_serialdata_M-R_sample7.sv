module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE       = 4'b0001;
    localparam RECEIVE    = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Enable signals
    wire receive_en = (state == RECEIVE);
    wire load_done;

    // State register
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state combinational logic (one-hot)
    always @(*) begin
        case (state)
            IDLE:       next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:    next_state = (bit_cnt == 3'd7) ? CHECK_STOP : RECEIVE;
            CHECK_STOP: next_state = (in == 1'b1) ? IDLE : RECOVER;
            RECOVER:    next_state = (in == 1'b1) ? IDLE : RECOVER;
            default:    next_state = IDLE;
        endcase
    end

    // Bit counter logic: count bits only in RECEIVE state
    always @(posedge clk) begin
        if (reset)
            bit_cnt <= 3'd0;
        else if (state == IDLE || state == CHECK_STOP || state == RECOVER)
            bit_cnt <= 3'd0;
        else if (receive_en)
            bit_cnt <= bit_cnt + 3'd1;
    end

    // Shift register: shift in bits LSB first on RECEIVE state
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (receive_en)
            // Shift right, new bit into MSB side to preserve LSB first order after full byte
            shift_reg <= {in, shift_reg[7:1]};
    end

    // Output and done signal logic
    reg done_reg;
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
            done_reg <= 1'b0;
        end else begin
            done <= done_reg;        // done asserted for one cycle
            done_reg <= 1'b0;        // clear done_reg by default

            if (state == CHECK_STOP && in == 1'b1) begin
                done_reg <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

endmodule