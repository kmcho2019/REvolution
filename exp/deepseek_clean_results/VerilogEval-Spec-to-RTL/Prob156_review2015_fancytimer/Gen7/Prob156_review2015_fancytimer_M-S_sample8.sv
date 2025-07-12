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
    localparam IDLE         = 2'b00;
    localparam CAPTURE_DELAY = 2'b01;
    localparam COUNTING     = 2'b10;
    localparam DONE         = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [2:0] bit_counter;
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] remaining_chunks;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 0;
                    end
                    counting <= 0;
                    done <= 0;
                end

                CAPTURE_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3) begin
                        state <= COUNTING;
                        remaining_chunks <= delay_val;
                        cycle_counter <= 0;
                        counting <= 1;
                        count <= delay_val;
                    end
                end

                COUNTING: begin
                    cycle_counter <= cycle_counter + 1;
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        remaining_chunks <= remaining_chunks - 1;
                        count <= remaining_chunks - 1;
                        if (remaining_chunks == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule