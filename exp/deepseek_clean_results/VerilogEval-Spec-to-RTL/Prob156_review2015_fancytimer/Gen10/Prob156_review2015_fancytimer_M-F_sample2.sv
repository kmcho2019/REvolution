module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // One-hot state encoding
    localparam IDLE          = 4'b0001;
    localparam CAPTURE_DELAY = 4'b0010;
    localparam COUNTING      = 4'b0100;
    localparam DONE          = 4'b1000;

    reg [3:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [1:0] bit_counter;
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] remaining_chunks;

    // Pattern detection (combinational)
    wire pattern_match = (pattern_reg == 4'b1101);

    // Output assignments
    assign counting = (state == COUNTING);
    assign done = (state == DONE);
    assign count = (state == COUNTING) ? remaining_chunks : 4'b0;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            bit_counter <= 0;
            cycle_counter <= 0;
            remaining_chunks <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_match) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 0;
                    end
                end

                CAPTURE_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    if (bit_counter == 3) begin
                        state <= COUNTING;
                        remaining_chunks <= delay_val;  // Use full captured value
                        cycle_counter <= 0;
                    end
                    bit_counter <= bit_counter + 1;
                end

                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (remaining_chunks == 0) begin
                            state <= DONE;
                        end else begin
                            remaining_chunks <= remaining_chunks - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule