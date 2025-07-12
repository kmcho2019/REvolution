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
    localparam IDLE     = 2'b00;
    localparam COUNTING = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [3:0] pattern_reg;  // For detecting 1101
    reg [3:0] delay_reg;    // For storing delay value
    reg [9:0] cycle_counter; // Counts 0-999 (10 bits for 1000 cycles)
    reg [3:0] delay_count;  // Counts down delay intervals
    reg pattern_matched;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            cycle_counter <= 10'b0;
            delay_count <= 4'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            pattern_matched <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    // Check for pattern 1101
                    if (pattern_reg == 4'b1101 && !pattern_matched) begin
                        pattern_matched <= 1'b1;
                        delay_reg <= 4'b0;  // Prepare to capture delay
                    end
                    else if (pattern_matched) begin
                        // Shift in delay bits (MSB first)
                        if (delay_reg != 4'b1111) begin  // Marker for complete capture
                            delay_reg <= {delay_reg[2:0], data};
                            
                            // After 4 bits, start counting
                            if (&delay_reg[2:0]) begin  // All bits shifted in
                                state <= COUNTING;
                                delay_count <= {delay_reg[2:0], data};
                                count <= {delay_reg[2:0], data};
                                cycle_counter <= 10'b0;
                                counting <= 1'b1;
                                pattern_matched <= 1'b0;
                            end
                        end
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (delay_count == 4'b0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end
                        else begin
                            delay_count <= delay_count - 1;
                            count <= delay_count - 1;
                        end
                    end
                    else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        pattern_reg <= 4'b0;
                        delay_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule