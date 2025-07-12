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
    localparam IDLE     = 2'b00;
    localparam COUNTING = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [2:0] bit_counter;
    reg [15:0] cycle_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 16'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    if (pattern_reg == 4'b1101 && bit_counter == 0) begin
                        bit_counter <= 3'd4; // Start capturing delay bits
                    end
                    
                    if (bit_counter > 0) begin
                        delay_val <= {delay_val[2:0], data};
                        bit_counter <= bit_counter - 1;
                        
                        if (bit_counter == 1) begin // Last delay bit captured
                            state <= COUNTING;
                            counting <= 1'b1;
                            cycle_counter <= (delay_val << 10) + (delay_val << 8) + 
                                           (delay_val << 7) + (delay_val << 6) + 
                                           (delay_val << 5) + (delay_val << 2);
                            // Above equals (delay_val+1)*1000 - 1
                        end
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 0) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
                        count <= cycle_counter / 1000; // Auto truncates to integer
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule