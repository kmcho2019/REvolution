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
    localparam IDLE        = 0;
    localparam PATTERN     = 1;
    localparam READ_DELAY  = 2;
    localparam COUNTING    = 3;
    localparam DONE        = 4;

    reg [2:0] state;
    reg [3:0] delay;
    reg [9:0] cycle_counter; // Counts up to 1000 cycles (10 bits)
    reg [3:0] pattern_reg;   // Shift register for pattern detection
    reg [1:0] bit_counter;   // Counts 4 delay bits

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 0;
            delay <= 0;
            cycle_counter <= 0;
            pattern_reg <= 0;
            bit_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 0;
                    counting <= 0;
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= READ_DELAY;
                        bit_counter <= 0;
                    end
                end
                
                READ_DELAY: begin
                    delay <= {delay[2:0], data};
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 3) begin
                        state <= COUNTING;
                        counting <= 1;
                        cycle_counter <= 0;
                        count <= delay;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (count == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            count <= count - 1;
                            cycle_counter <= cycle_counter + 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        pattern_reg <= 0;
                    end
                end
            endcase
        end
    end

endmodule