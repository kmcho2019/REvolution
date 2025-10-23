module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // One-hot state encoding
    localparam S_IDLE      = 4'b0001;
    localparam S_PATTERN   = 4'b0010;
    localparam S_CAPTURE   = 4'b0100;
    localparam S_COUNT     = 4'b1000;

    reg [3:0] state;
    reg [7:0] shift_reg;
    reg [9:0] prescaler;  // Counts to 1000
    reg [15:0] main_counter;
    reg [3:0] delay_value;
    reg pattern_matched;

    // Parallel pattern detection (looking for "1101" in last 4 bits)
    always @(posedge clk) begin
        if (reset) begin
            shift_reg <= 8'b0;
            pattern_matched <= 0;
        end else begin
            shift_reg <= {shift_reg[6:0], data};
            pattern_matched <= (shift_reg[3:0] == 4'b1101);
        end
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            prescaler <= 0;
            main_counter <= 0;
            delay_value <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    done <= 0;
                    if (pattern_matched) begin
                        state <= S_PATTERN;
                    end
                end

                S_PATTERN: begin
                    state <= S_CAPTURE;
                    delay_value <= shift_reg[7:4];  // Next 4 bits after pattern
                end

                S_CAPTURE: begin
                    counting <= 1;
                    main_counter <= (delay_value + 1) * 1000;
                    count <= delay_value;
                    state <= S_COUNT;
                end

                S_COUNT: begin
                    if (prescaler == 999) begin
                        prescaler <= 0;
                        main_counter <= main_counter - 1;
                        if (main_counter % 1000 == 0) begin
                            count <= count - 1;
                        end
                    end else begin
                        prescaler <= prescaler + 1;
                    end

                    if (main_counter == 1) begin
                        counting <= 0;
                        done <= 1;
                        state <= S_IDLE;
                    end
                end
            endcase

            // Handle ack in any state when done is asserted
            if (done && ack) begin
                done <= 0;
                state <= S_IDLE;
            end
        end
    end

endmodule