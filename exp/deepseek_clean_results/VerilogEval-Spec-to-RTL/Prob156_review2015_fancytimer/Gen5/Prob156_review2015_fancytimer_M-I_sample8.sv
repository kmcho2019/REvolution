module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // FSM states
    parameter IDLE = 2'b00;
    parameter CAPTURE = 2'b01;
    parameter RUN = 2'b10;
    parameter COMPLETE = 2'b11;

    reg [1:0] state;

    // Pattern detection
    reg [3:0] pattern_reg;
    wire pattern_match = (pattern_reg == 4'b1101);

    // Delay capture
    reg [3:0] delay_reg;
    reg [2:0] bit_count;
    reg [3:0] delay_value;

    // Timing counters
    reg [9:0] cycle_count;  // Counts 0-999 (1000 cycles)
    reg [3:0] delay_count;  // Current delay countdown

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_count <= 3'b0;
            delay_value <= 4'b0;
            cycle_count <= 10'b0;
            delay_count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    
                    if (pattern_match) begin
                        state <= CAPTURE;
                        pattern_reg <= 4'b0;
                    end
                end

                CAPTURE: begin
                    if (bit_count < 4) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_count <= bit_count + 1;
                    end else begin
                        state <= RUN;
                        delay_value <= delay_reg;
                        delay_count <= delay_reg;
                        cycle_count <= 10'b0;
                        counting <= 1'b1;
                    end
                end

                RUN: begin
                    if (cycle_count == 10'd999) begin
                        cycle_count <= 10'b0;
                        if (delay_count == 4'b0) begin
                            state <= COMPLETE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            delay_count <= delay_count - 1;
                        end
                    end else begin
                        cycle_count <= cycle_count + 1;
                    end
                    count <= delay_count;
                end

                COMPLETE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        bit_count <= 3'b0;
                    end
                end
            endcase
        end
    end

endmodule