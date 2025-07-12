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
    localparam IDLE     = 1'b0;
    localparam COUNTING = 1'b1;
    localparam DONE     = 1'b1; // Same as COUNTING but distinguished by done signal

    reg state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [13:0] main_counter; // [13:10] = delay count, [9:0] = cycle count

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            main_counter <= 14'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    // When pattern matches, prepare for delay capture
                    if (pattern_reg == 4'b1101) begin
                        delay_val <= 4'b0;
                        state <= COUNTING;
                        counting <= 1'b1;
                        done <= 1'b0;
                    end
                end
                
                COUNTING: begin
                    // First capture delay value (4 bits after pattern)
                    if (main_counter[9:0] < 4) begin
                        delay_val <= {delay_val[2:0], data};
                        main_counter <= main_counter + 1;
                    end 
                    // Then start counting
                    else begin
                        if (main_counter[9:0] == 10'd999) begin
                            main_counter[13:10] <= main_counter[13:10] - 1;
                            main_counter[9:0] <= 10'b0;
                            
                            // Check if counting complete
                            if (main_counter[13:10] == 4'b0) begin
                                state <= DONE;
                                counting <= 1'b0;
                                done <= 1'b1;
                            end
                        end else begin
                            main_counter[9:0] <= main_counter[9:0] + 1;
                        end
                    end
                    
                    // Output current countdown value
                    count <= main_counter[13:10];
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                        main_counter <= 14'b0;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule