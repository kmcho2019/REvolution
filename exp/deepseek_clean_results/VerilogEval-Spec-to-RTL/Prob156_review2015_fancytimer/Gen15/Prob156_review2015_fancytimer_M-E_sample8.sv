module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // One-hot state encoding
    localparam [3:0] 
        IDLE          = 4'b0001,
        CAPTURE_DELAY = 4'b0010,
        COUNTING      = 4'b0100,
        NOTIFY        = 4'b1000;

    reg [3:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_value;
    reg [2:0] bit_counter;
    reg [9:0] cycle_counter;
    reg [3:0] interval_counter;

    // Parallel pattern detection
    wire pattern_match = (pattern_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_value <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 10'b0;
            interval_counter <= 4'b0;
            count <= 4'b0;
        end else begin
            pattern_reg <= {pattern_reg[2:0], data};

            case (1'b1)
                state[0]: begin // IDLE
                    if (pattern_match) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 3'b0;
                    end
                end

                state[1]: begin // CAPTURE_DELAY
                    delay_value <= {delay_value[2:0], data};
                    bit_counter <= bit_counter + 1;

                    if (bit_counter == 3'b011) begin
                        state <= COUNTING;
                        interval_counter <= delay_value;
                        cycle_counter <= 10'b0;
                        count <= delay_value;
                    end
                end

                state[2]: begin // COUNTING
                    cycle_counter <= cycle_counter + 1;

                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        interval_counter <= interval_counter - 1;
                        count <= interval_counter - 1;

                        if (interval_counter == 4'b0) begin
                            state <= NOTIFY;
                        end
                    end
                end

                state[3]: begin // NOTIFY
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

    assign counting = state[2]; // COUNTING state
    assign done = state[3];     // NOTIFY state

endmodule