module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding
    localparam [3:0]
        IDLE       = 4'b0001,
        RECEIVE    = 4'b0010,
        CHECK_STOP = 4'b0100,
        RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // Clock enable signal for receive state
    wire recv_en = (state == RECEIVE);

    // Sequential logic for state and data
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;

            // Default done low, asserted only on valid stop bit detection
            done <= 1'b0;

            if (recv_en) begin
                // Shift left, LSB first: incoming bit goes into bit 0
                shift_reg <= {in, shift_reg[7:1]};
                bit_cnt <= bit_cnt + 3'd1;
            end else if (state == IDLE) begin
                bit_cnt <= 3'd0;
                shift_reg <= 8'd0;
            end

            if (state == CHECK_STOP) begin
                if (in == 1'b1) begin
                    done <= 1'b1;
                    out_byte <= shift_reg;
                end
                bit_cnt <= 3'd0; // Reset bit count after stop bit check
            end
            // In RECOVER state, hold shift_reg and bit_cnt stable implicitly
        end
    end

    // Next-state combinational logic
    always @(*) begin
        case (state)
            IDLE:
                next_state = (in == 1'b0) ? RECEIVE : IDLE;
            RECEIVE:
                next_state = (bit_cnt == 3'd7) ? CHECK_STOP : RECEIVE;
            CHECK_STOP:
                next_state = (in == 1'b1) ? IDLE : RECOVER;
            RECOVER:
                next_state = (in == 1'b1) ? IDLE : RECOVER;
            default:
                next_state = IDLE;
        endcase
    end

endmodule