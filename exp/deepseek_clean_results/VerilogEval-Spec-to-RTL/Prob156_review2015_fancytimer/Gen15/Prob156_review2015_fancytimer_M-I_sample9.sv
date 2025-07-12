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
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [3:0] main_counter;
    reg [9:0] sub_counter;
    reg [2:0] bit_counter;  // Now 3-bit to count 0-4

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            main_counter <= 4'b0;
            sub_counter <= 10'b0;
            bit_counter <= 3'b0;
            count <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in new data
                    pattern_reg <= {pattern_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    count <= 4'b0;
                    
                    // Check for pattern match
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_counter <= 3'b0;
                    end
                end
                
                CAPTURE: begin
                    // Shift in delay bits
                    delay_reg <= {delay_reg[2:0], data};
                    
                    if (bit_counter == 3'd3) begin
                        state <= COUNTING;
                        main_counter <= delay_reg;
                        sub_counter <= 10'b0;
                        counting <= 1'b1;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                COUNTING: begin
                    if (sub_counter == 10'd999) begin
                        sub_counter <= 10'b0;
                        if (main_counter == 4'b0) begin
                            state <= DONE;
                            counting <= 1'b0;
                            done <= 1'b1;
                        end else begin
                            main_counter <= main_counter - 1;
                        end
                    end else begin
                        sub_counter <= sub_counter + 1;
                    end
                    count <= main_counter;
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        pattern_reg <= 4'b0;
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule