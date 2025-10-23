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
    localparam IDLE      = 2'b00;
    localparam CAPTURE   = 2'b01;
    localparam COUNT     = 2'b10;
    localparam DONE      = 2'b11;
    
    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [1:0] bit_cnt;
    reg [13:0] main_counter;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
            main_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    pattern_reg <= {pattern_reg[2:0], data};
                    
                    // Only check pattern when all 4 bits are filled
                    if (&pattern_reg[2:0]) begin
                        if (pattern_reg == 4'b1101) begin
                            state <= CAPTURE;
                            bit_cnt <= 0;
                            delay_val <= 0;
                        end
                    end
                end
                
                CAPTURE: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    
                    if (bit_cnt == 3) begin
                        state <= COUNT;
                        counting <= 1'b1;
                        main_counter <= (delay_val + 1) * 1000;
                    end
                end
                
                COUNT: begin
                    main_counter <= main_counter - 1;
                    count <= (main_counter - 1) / 1000;
                    
                    if (main_counter == 1) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
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