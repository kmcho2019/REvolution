module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam LOAD  = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_pipe;
    reg [3:0] delay_reg;
    reg [2:0] bit_count;
    reg [13:0] cycle_counter;  // Enough for 15*1000=15000 cycles
    reg [3:0] delay_counter;
    wire pattern_match;

    // Pattern detection
    assign pattern_match = (pattern_pipe == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            pattern_pipe <= 4'b0;
        end else begin
            pattern_pipe <= {pattern_pipe[2:0], data};
        end
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            delay_reg <= 4'b0;
            bit_count <= 0;
            cycle_counter <= 0;
            delay_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 0;
                    done <= 0;
                    count <= 4'b0;
                    if (pattern_match) begin
                        state <= LOAD;
                        bit_count <= 0;
                    end
                end

                LOAD: begin
                    if (bit_count < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= COUNT;
                        counting <= 1;
                        delay_counter <= delay_reg;
                        cycle_counter <= 0;
                    end
                end

                COUNT: begin
                    if (cycle_counter == (delay_reg + 1) * 1000 - 1) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                        // Update count output every 1000 cycles
                        count <= delay_reg - (cycle_counter / 1000);
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule