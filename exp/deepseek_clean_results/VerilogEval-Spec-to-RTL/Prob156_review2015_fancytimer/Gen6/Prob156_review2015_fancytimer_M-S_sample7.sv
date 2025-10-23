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
    localparam COUNTING = 1;
    localparam DONE = 2;
    
    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [9:0] cycle_counter;
    reg [1:0] bit_counter;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            cycle_counter <= 10'b0;
            bit_counter <= 2'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    counting <= 1'b0;
                    done <= 1'b0;
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    if (pattern_reg == 4'b1101) begin
                        // Start capturing delay bits
                        bit_counter <= 2'b0;
                        delay_val <= 4'b0;
                    end else if (bit_counter < 2'b11) begin
                        // Capture delay bits
                        delay_val <= {delay_val[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end else if (bit_counter == 2'b11) begin
                        // Start counting
                        state <= COUNTING;
                        counting <= 1'b1;
                        cycle_counter <= 10'b0;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        delay_val <= delay_val - 1;
                        
                        if (delay_val == 4'b0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                    count <= delay_val;
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule