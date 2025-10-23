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
    localparam CAPTURE  = 2'b01;
    localparam COUNTING = 2'b10;
    localparam DONE     = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [2:0] bit_counter;
    reg [15:0] main_counter;  // Enough for max delay (15+1)*1000=16000 cycles

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_counter <= 3'b0;
            main_counter <= 16'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    // Shift in new data for pattern detection
                    pattern_reg <= {pattern_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 3'd3 && pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_counter <= 3'b0;
                    end else if (bit_counter == 3'd3) begin
                        bit_counter <= 3'b0;
                    end
                end

                CAPTURE: begin
                    // Shift in next 4 bits for delay value
                    delay_reg <= {delay_reg[2:0], data};
                    bit_counter <= bit_counter + 1;
                    
                    if (bit_counter == 3'd3) begin
                        state <= COUNTING;
                        counting <= 1'b1;
                        main_counter <= 16'b0;
                    end
                end

                COUNTING: begin
                    if (main_counter == (delay_reg + 1) * 1000 - 1) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        main_counter <= main_counter + 1;
                        // Update count output (delay_reg - cycles_completed/1000)
                        count <= delay_reg - (main_counter / 1000);
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 1'b0;
                        count <= 4'b0;
                        bit_counter <= 3'b0;
                    end
                end
            endcase
        end
    end

endmodule