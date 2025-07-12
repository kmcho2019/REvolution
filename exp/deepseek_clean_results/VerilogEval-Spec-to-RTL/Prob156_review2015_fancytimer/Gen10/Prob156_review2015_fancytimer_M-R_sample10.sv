module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // One-hot state encoding
    localparam IDLE      = 4'b0001;
    localparam CAPTURE   = 4'b0010;
    localparam COUNT     = 4'b0100;
    localparam DONE      = 4'b1000;
    
    reg [3:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [1:0] bit_cnt;
    reg [9:0] sub_counter;  // Counts 0-999
    reg [3:0] delay_counter;
    
    // Pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end
    
    // State machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay_val <= 4'b0;
            bit_cnt <= 2'b0;
            sub_counter <= 10'b0;
            delay_counter <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_cnt <= 2'b0;
                    end
                end
                
                CAPTURE: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    
                    if (bit_cnt == 3) begin
                        state <= COUNT;
                        delay_counter <= delay_val;
                        sub_counter <= 10'b0;
                    end
                end
                
                COUNT: begin
                    sub_counter <= sub_counter + 1;
                    
                    if (sub_counter == 999) begin
                        sub_counter <= 10'b0;
                        delay_counter <= delay_counter - 1;
                        
                        if (delay_counter == 0) begin
                            state <= DONE;
                        end
                    end
                end
                
                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
    
    // Output logic
    assign count = (state == COUNT) ? delay_counter : 4'b0;
    assign counting = (state == COUNT);
    assign done = (state == DONE);

endmodule