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
    localparam IDLE = 0;
    localparam CAPTURE_DELAY = 1;
    localparam COUNTING = 2;
    localparam DONE = 3;
    
    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] period_counter; // Counts delay periods
    reg [2:0] bit_counter;    // Counts 0-3 for delay bits

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            cycle_counter <= 10'b0;
            period_counter <= 4'b0;
            bit_counter <= 3'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                        bit_counter <= 3'b0;
                        delay_val <= 4'b0;
                        pattern_reg <= 4'b0; // Clear pattern to prevent retrigger
                    end
                end
                
                CAPTURE_DELAY: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 3'b11) begin
                        state <= COUNTING;
                        counting <= 1'b1;
                        cycle_counter <= 10'b0;
                        period_counter <= delay_val;
                        count <= delay_val; // Initialize count output
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (period_counter == 4'b0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            period_counter <= period_counter - 1;
                            count <= period_counter - 1; // Update count at period boundary
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule