module TopModule (
    input  wire       clk,
    input  wire       in,
    input  wire       reset,
    output reg  [7:0] out_byte,
    output reg        done
);

    // One-hot state encoding for 4 states
    localparam IDLE       = 4'b0001;
    localparam READ_BITS  = 4'b0010;
    localparam CHECK_STOP = 4'b0100;
    localparam RECOVER    = 4'b1000;

    reg [3:0] state, next_state;
    reg [2:0] bit_cnt;
    reg [7:0] shift_reg;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state     <= IDLE;
            bit_cnt   <= 3'd0;
            shift_reg <= 8'd0;
            done      <= 1'b0;
            out_byte  <= 8'd0;
        end else begin
            state <= next_state;
            // done is cleared only when new start bit detected (in IDLE)
            if (state == IDLE && in == 1'b0)
                done <= 1'b0;
        end
    end

    // Shift register and bit counter update
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'd0;
            bit_cnt   <= 3'd0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= 8'd0;
                    bit_cnt <= 3'd0;
                end
                READ_BITS: begin
                    // Shift left, input bit goes into LSB (LSB first)
                    shift_reg <= {in, shift_reg[7:1]};
                    bit_cnt <= bit_cnt + 1'b1;
                end
                default: begin
                    // Maintain counters and shift_reg
                    bit_cnt <= bit_cnt;
                    shift_reg <= shift_reg;
                end
            endcase
        end
    end

    // Output logic and done signal generation
    always @(posedge clk) begin
        if (reset) begin
            done <= 1'b0;
            out_byte <= 8'd0;
        end else if (state == CHECK_STOP) begin
            if (in == 1'b1) begin
                out_byte <= shift_reg;
                done <= 1'b1; // pulse done for one cycle
            end else begin
                done <= 1'b0;
            end
        end else if (state == IDLE && in == 1'b0) begin
            // Clear done at start bit detection for new frame
            done <= 1'b0;
        end else begin
            done <= 1'b0;
        end
    end

    // Next state logic with one-hot encoding
    always @(*) begin
        next_state = 4'b0000;
        case (1'b1) // synthesizable one-hot style
            state[0]: // IDLE
                next_state = (in == 1'b0) ? READ_BITS : IDLE;
            state[1]: // READ_BITS
                next_state = (bit_cnt == 3'd7) ? CHECK_STOP : READ_BITS;
            state[2]: // CHECK_STOP
                next_state = (in == 1'b1) ? IDLE : RECOVER;
            state[3]: // RECOVER
                next_state = (in == 1'b1) ? IDLE : RECOVER;
            default:
                next_state = IDLE;
        endcase
    end

endmodule