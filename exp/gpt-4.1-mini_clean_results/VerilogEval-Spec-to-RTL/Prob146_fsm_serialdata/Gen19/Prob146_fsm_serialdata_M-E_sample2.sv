module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam IDLE         = 5'b00001;
    localparam START_DETECT = 5'b00010;
    localparam RECEIVE      = 5'b00100;
    localparam STOP_CHECK   = 5'b01000;
    localparam RECOVER      = 5'b10000;

    reg [4:0] state, next_state;
    reg [2:0] bit_count;
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (in == 1'b0)
                    next_state = START_DETECT;
                else
                    next_state = IDLE;
            end
            START_DETECT: begin
                // Confirm start bit still low on next clock to avoid glitch
                if (in == 1'b0)
                    next_state = RECEIVE;
                else
                    next_state = IDLE;
            end
            RECEIVE: begin
                if (bit_count == 3'd7)
                    next_state = STOP_CHECK;
                else
                    next_state = RECEIVE;
            end
            STOP_CHECK: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end
            RECOVER: begin
                if (in == 1'b1)
                    next_state = IDLE;
                else
                    next_state = RECOVER;
            end
            default: next_state = IDLE;
        endcase
    end

    // Bit count and shift register update
    always @(posedge clk) begin
        if (reset) begin
            bit_count <= 3'd0;
            shift_reg <= 8'd0;
        end else begin
            if (state == RECEIVE) begin
                shift_reg <= {in, shift_reg[7:1]};  // Shift in LSB first: shift right, input bit into MSB
                bit_count <= bit_count + 1;
            end else begin
                bit_count <= 3'd0;
                if (state == IDLE)
                    shift_reg <= 8'd0;
            end
        end
    end

    // Output logic: done and out_byte
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else begin
            done <= 1'b0;
            if (state == STOP_CHECK && in == 1'b1) begin
                done <= 1'b1;
                out_byte <= shift_reg;
            end
        end
    end

endmodule