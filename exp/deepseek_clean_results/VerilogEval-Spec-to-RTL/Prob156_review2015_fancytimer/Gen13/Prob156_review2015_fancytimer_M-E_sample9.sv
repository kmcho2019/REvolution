module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    localparam SEARCH = 2'b00;
    localparam LOAD   = 2'b01;
    localparam RUN    = 2'b10;
    localparam FINISH = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern;      // Shift register for pattern detection
    reg [3:0] delay_reg;    // Captured delay value
    reg [2:0] bit_count;    // Counts 0-3 for delay capture
    reg [9:0] prescaler;    // Divides clock by 1000
    reg [3:0] delay_count;  // Counts down delay chunks
    reg pattern_matched;    // Parallel pattern detection

    // Parallel pattern detection (1101)
    always @(*) begin
        pattern_matched = (pattern == 4'b1101);
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= SEARCH;
            pattern <= 4'b0;
            delay_reg <= 4'b0;
            bit_count <= 3'b0;
            prescaler <= 10'b0;
            delay_count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                SEARCH: begin
                    pattern <= {pattern[2:0], data};
                    if (pattern_matched) begin
                        state <= LOAD;
                        bit_count <= 3'b0;
                    end
                end

                LOAD: begin
                    delay_reg <= {delay_reg[2:0], data};
                    bit_count <= bit_count + 1;
                    if (bit_count == 3'd3) begin
                        state <= RUN;
                        delay_count <= delay_reg;
                        prescaler <= 10'b0;
                        counting <= 1'b1;
                    end
                end

                RUN: begin
                    if (prescaler == 10'd999) begin
                        prescaler <= 10'b0;
                        if (delay_count == 4'b0) begin
                            state <= FINISH;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            delay_count <= delay_count - 1;
                        end
                    end else begin
                        prescaler <= prescaler + 1;
                    end
                    count <= delay_count;
                end

                FINISH: begin
                    if (ack) begin
                        state <= SEARCH;
                        done <= 1'b0;
                        pattern <= 4'b0;
                        count <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule