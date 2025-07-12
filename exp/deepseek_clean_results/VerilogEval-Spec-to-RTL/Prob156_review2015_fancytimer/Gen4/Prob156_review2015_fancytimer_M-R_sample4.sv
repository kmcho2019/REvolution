module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam LOAD  = 2'b01;
    localparam COUNT = 2'b10;
    localparam DONE  = 2'b11;
    
    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [1:0] bit_cnt;
    reg [13:0] cycle_counter;
    reg [13:0] target_cycles;
    reg [3:0] delay_reg;
    
    // Pattern detection
    wire pattern_match = (pattern_reg == 4'b1101);
    
    // Output assignments
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    assign count = (state == COUNT) ? (target_cycles - cycle_counter) / 1000 : 4'b0;
    
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            bit_cnt <= 0;
            cycle_counter <= 0;
            target_cycles <= 0;
            delay_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_match) begin
                        state <= LOAD;
                        bit_cnt <= 0;
                    end
                end
                
                LOAD: begin
                    delay_reg <= {delay_reg[2:0], data};
                    if (bit_cnt == 3) begin
                        target_cycles <= (delay_reg[3:0] + 1) * 1000;
                        cycle_counter <= 0;
                        state <= COUNT;
                    end
                    bit_cnt <= bit_cnt + 1;
                end
                
                COUNT: begin
                    if (cycle_counter == target_cycles - 1) begin
                        state <= DONE;
                    end
                    cycle_counter <= cycle_counter + 1;
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