module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // State encoding (binary)
    localparam IDLE         = 3'd0;
    localparam WAIT_START   = 3'd1;
    localparam RECEIVE_BITS = 3'd2;
    localparam CHECK_STOP   = 3'd3;
    localparam WAIT_IDLE    = 3'd4;

    reg [2:0] state, next_state;
    reg [2:0] bit_idx;          // Counts 0 to 7 during data bit reception
    reg [7:0] shift_reg;

    // FSM state register with synchronous reset
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Bit index counter, increments only during RECEIVE_BITS state
    always @(posedge clk) begin
        if (reset)
            bit_idx <= 3'd0;
        else if (state == RECEIVE_BITS)
            bit_idx <= bit_idx + 3'd1;
        else
            bit_idx <= 3'd0;
    end

    // Shift register, shift in bits LSB first during RECEIVE_BITS
    always @(posedge clk) begin
        if (reset)
            shift_reg <= 8'd0;
        else if (state == RECEIVE_BITS)
            shift_reg <= {in, shift_reg[7:1]};
        else if (state == IDLE)
            shift_reg <= 8'd0;
    end

    // done and out_byte update
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0;
            if (state == CHECK_STOP && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                // Wait for start bit (0)
                if (in == 1'b0)
                    next_state = WAIT_START;
                else
                    next_state = IDLE;
            end

            WAIT_START: begin
                // Confirm start bit still low to avoid glitch
                if (in == 1'b0)
                    next_state = RECEIVE_BITS;
                else
                    next_state = IDLE;
            end

            RECEIVE_BITS: begin
                if (bit_idx == 3'd7)
                    next_state = CHECK_STOP;
                else
                    next_state = RECEIVE_BITS;
            end

            CHECK_STOP: begin
                if (in == 1'b1)
                    next_state = IDLE;       // Valid stop bit, byte done
                else
                    next_state = WAIT_IDLE;  // Invalid stop bit, wait for idle
            end

            WAIT_IDLE: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = WAIT_IDLE;
            end

            default: next_state = IDLE;
        endcase
    end

endmodule