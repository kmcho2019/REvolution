module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0]  yout,
    output reg         done
);

    // Define states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        CALC = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    reg [4:0] bit_idx;          // 5-bit counter 0-16 for shift count
    reg [15:0] areg;            // multiplicand register (shift right)
    reg [31:0] breg_ext;        // multiplier extended and shifted left
    reg [31:0] acc;             // accumulator register

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next-state logic
    always @(*) begin
        case (state)
            IDLE: begin
                if (start)
                    next_state = LOAD;
                else
                    next_state = IDLE;
            end
            LOAD: begin
                next_state = CALC;
            end
            CALC: begin
                if (bit_idx == 5'd16)
                    next_state = DONE;
                else
                    next_state = CALC;
            end
            DONE: begin
                next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Control and data path
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_idx  <= 5'd0;
            areg    <= 16'd0;
            breg_ext <= 32'd0;
            acc     <= 32'd0;
            yout    <= 32'd0;
            done    <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    bit_idx <= 5'd0;
                    areg    <= 16'd0;
                    breg_ext <= 32'd0;
                    acc     <= 32'd0;
                    yout    <= 32'd0;
                    done    <= 1'b0;
                end

                LOAD: begin
                    areg     <= ain;
                    breg_ext <= {16'd0, bin};
                    acc      <= 32'd0;
                    bit_idx  <= 5'd0;
                    done     <= 1'b0;
                end

                CALC: begin
                    // Accumulate if LSB of areg is set
                    if (areg[0]) begin
                        acc <= acc + breg_ext;
                    end else begin
                        acc <= acc;
                    end

                    // Shift registers for next bit
                    areg     <= areg >> 1;
                    breg_ext <= breg_ext << 1;

                    // Increment bit index
                    bit_idx <= bit_idx + 5'd1;

                    done <= 1'b0;
                end

                DONE: begin
                    yout <= acc;
                    done <= 1'b1;
                    // Hold registers stable
                    bit_idx  <= bit_idx;
                    areg     <= areg;
                    breg_ext <= breg_ext;
                    acc      <= acc;
                end

                default: begin
                    bit_idx <= 5'd0;
                    areg    <= 16'd0;
                    breg_ext <= 32'd0;
                    acc     <= 32'd0;
                    yout    <= 32'd0;
                    done    <= 1'b0;
                end
            endcase
        end
    end

endmodule