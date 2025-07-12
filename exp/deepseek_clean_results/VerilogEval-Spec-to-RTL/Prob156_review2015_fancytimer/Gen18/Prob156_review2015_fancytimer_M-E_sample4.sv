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
    localparam IDLE     = 2'b00;
    localparam COUNTING = 2'b01;
    localparam DONE     = 2'b10;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [2:0] bit_counter;
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] delay_counter;  // Counts down from delay_val

    // Combinational pattern detection
    wire pattern_match = (pattern_reg == 4'b1101);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_val <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 10'b0;
            delay_counter <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Update pattern register
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    if (pattern_match) begin
                        // Start capturing delay value
                        bit_counter <= 3'd0;
                        state <= IDLE;  // Stay in IDLE to capture delay
                    end
                    
                    // After pattern match, capture next 4 bits as delay
                    if (pattern_match || bit_counter > 0) begin
                        if (bit_counter < 4) begin
                            delay_val <= {delay_val[2:0], data};
                            bit_counter <= bit_counter + 1;
                        end
                        
                        if (bit_counter == 3) begin
                            // Got all delay bits, start counting
                            state <= COUNTING;
                            counting <= 1'b1;
                            delay_counter <= delay_val;
                            cycle_counter <= 10'b0;
                            count <= delay_val;
                        end
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        if (delay_counter == 4'b0) begin
                            // Counting complete
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            delay_counter <= delay_counter - 1;
                            count <= delay_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
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