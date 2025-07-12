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
    localparam IDLE     = 5'b00001;
    localparam DETECTED = 5'b00010;
    localparam LOAD     = 5'b00100;
    localparam COUNT    = 5'b01000;
    localparam FINISH   = 5'b10000;

    reg [4:0] state;
    reg [3:0] pattern_pipe;
    reg [3:0] delay_reg;
    reg [2:0] bit_count;
    reg [9:0] cycle_counter;
    reg [3:0] delay_counter;

    // Pipeline pattern detection
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
                    if (pattern_pipe == 4'b1101) begin
                        state <= DETECTED;
                        bit_count <= 0;
                    end
                end

                DETECTED: begin
                    state <= LOAD;
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
                        count <= delay_reg;
                    end
                end

                COUNT: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (delay_counter == 0) begin
                            state <= FINISH;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            delay_counter <= delay_counter - 1;
                            count <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                FINISH: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule