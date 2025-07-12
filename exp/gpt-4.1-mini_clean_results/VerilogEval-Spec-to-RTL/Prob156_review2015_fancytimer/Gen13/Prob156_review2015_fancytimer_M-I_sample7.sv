module TopModule(
    input        clk,
    input        reset,  // synchronous active high
    input        data,
    output reg [3:0] count,
    output reg   counting,
    output reg   done,
    input        ack
);

    // State encoding
    localparam [1:0]
        SEARCH     = 2'd0,
        LOAD_DELAY = 2'd1,
        COUNTING   = 2'd2,
        DONE_WAIT  = 2'd3;

    reg [1:0] state, next_state;

    // Shift register for detecting pattern 1101
    reg [3:0] pattern_shift;

    // Delay register to store 4 delay bits MSB first
    reg [3:0] delay_reg;

    // Counter counts down from (delay+1)*1000 to zero
    // 14 bits: max 16,000 fits inside 2^14 = 16,384
    reg [13:0] countdown;

    // Bit count for loading delay bits (0 to 4)
    reg [2:0] load_count;

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
        end else begin
            state <= next_state;
        end
    end

    // Shift in input data into pattern_shift only in SEARCH state
    always @(posedge clk) begin
        if (reset) begin
            pattern_shift <= 4'd0;
        end else if (state == SEARCH) begin
            pattern_shift <= {pattern_shift[2:0], data};
        end
    end

    // Load delay bits MSB first during LOAD_DELAY state
    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 4'd0;
            load_count <= 3'd0;
        end else if (state == LOAD_DELAY) begin
            // Shift in MSB first: new data in MSB position, shift right
            delay_reg <= {data, delay_reg[3:1]};
            load_count <= load_count + 1'b1;
        end else begin
            // Clear load_count outside LOAD_DELAY for safety
            load_count <= 3'd0;
            delay_reg <= delay_reg; // hold delay_reg unless loading
        end
    end

    // Countdown logic
    always @(posedge clk) begin
        if (reset) begin
            countdown <= 14'd0;
        end else begin
            case(state)
                COUNTING: begin
                    if (countdown != 14'd0)
                        countdown <= countdown - 1'b1;
                end
                LOAD_DELAY: begin
                    countdown <= 14'd0;
                end
                default: begin
                    countdown <= 14'd0;
                end
            endcase
        end
    end

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            SEARCH: begin
                if (pattern_shift == 4'b1101)
                    next_state = LOAD_DELAY;
            end
            LOAD_DELAY: begin
                if (load_count == 3'd4)
                    next_state = COUNTING;
            end
            COUNTING: begin
                if (countdown == 14'd0)
                    next_state = DONE_WAIT;
            end
            DONE_WAIT: begin
                if (ack)
                    next_state = SEARCH;
            end
        endcase
    end

    // Initialize countdown at start of COUNTING state (on transition from LOAD_DELAY)
    reg load_delay_d; // delayed LOAD_DELAY state signal
    always @(posedge clk) begin
        if (reset) begin
            load_delay_d <= 1'b0;
        end else begin
            load_delay_d <= (state == LOAD_DELAY);
        end
    end

    // Load countdown on LOAD_DELAY->COUNTING transition
    always @(posedge clk) begin
        if (reset) begin
            countdown <= 14'd0;
        end else if ((load_delay_d == 1'b1) && (state == COUNTING)) begin
            // Load countdown = (delay + 1)*1000
            // multiply by 1000 = multiply by 1024 - 24 (approximate)
            // but better to do exact multiplication by 1000 = delay*1000 + 1000
            // Since delay is 4 bits, direct multiplication is straightforward:
            countdown <= (delay_reg + 1) * 14'd1000;
        end
    end

    // Output logic synchronous
    always @(posedge clk) begin
        if (reset) begin
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'd0;
        end else begin
            case(state)
                SEARCH: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care, will synthesize as latch unless overwritten
                end
                LOAD_DELAY: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care
                end
                COUNTING: begin
                    counting <= 1'b1;
                    done <= 1'b0;
                    // Compute current count = remaining thousands of cycles - 1
                    // count = countdown / 1000 - 1 if countdown>0 else 0
                    // To get division by 1000 (non-power of two), use:
                    // integer div = countdown / 1000
                    // We can approximate since count is only 4 bits (0-16 max)
                    // Use integer division with '/' operator - synthesizable in FPGA/ASIC tools

                    // if countdown==0, count=0
                    if (countdown == 0)
                        count <= 4'd0;
                    else begin
                        // integer division by 1000 to get which 1000-cycle block is counting
                        // final count is div-1, but minimum 0
                        // careful not to underflow if div==0 (should not happen)
                        // Use a temp integer
                        integer div_1000;
                        div_1000 = countdown / 1000;
                        if (div_1000 > 0)
                            count <= div_1000[3:0] - 4'd1;
                        else
                            count <= 4'd0;
                    end
                end
                DONE_WAIT: begin
                    counting <= 1'b0;
                    done <= 1'b1;
                    count <= 4'bxxxx; // don't care
                end
                default: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'bxxxx; // don't care
                end
            endcase
        end
    end

endmodule