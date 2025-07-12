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
    localparam IDLE         = 3'b000;
    localparam DETECT       = 3'b001;
    localparam CAPTURE      = 3'b010;
    localparam COUNT        = 3'b011;
    localparam COMPLETE     = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern;
    reg [3:0] delay;
    reg [3:0] bit_cnt;
    reg [15:0] main_counter;
    reg [3:0] count_reg;
    
    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset) begin
            pattern <= 4'b0;
        end else if (state == IDLE || state == DETECT) begin
            pattern <= {pattern[2:0], data};
        end
    end

    // Bit counter for pattern and delay capture
    always @(posedge clk) begin
        if (reset) begin
            bit_cnt <= 0;
        end else begin
            case (state)
                IDLE: bit_cnt <= (bit_cnt == 3) ? 0 : bit_cnt + 1;
                DETECT: bit_cnt <= 0;
                CAPTURE: bit_cnt <= (bit_cnt == 3) ? 0 : bit_cnt + 1;
                default: bit_cnt <= 0;
            endcase
        end
    end

    // Delay capture
    always @(posedge clk) begin
        if (reset) begin
            delay <= 4'b0;
        end else if (state == CAPTURE) begin
            delay <= {delay[2:0], data};
        end
    end

    // Main state machine
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            main_counter <= 0;
            count_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (bit_cnt == 3) state <= DETECT;
                end
                
                DETECT: begin
                    if (pattern == 4'b1101) state <= CAPTURE;
                    else state <= IDLE;
                end
                
                CAPTURE: begin
                    if (bit_cnt == 3) begin
                        state <= COUNT;
                        main_counter <= (delay + 1) * 1000 - 1;
                        count_reg <= delay;
                    end
                end
                
                COUNT: begin
                    if (main_counter == 0) begin
                        state <= COMPLETE;
                    end else begin
                        main_counter <= main_counter - 1;
                        // Update count every 1000 cycles
                        if (main_counter % 1000 == 0) count_reg <= count_reg - 1;
                    end
                end
                
                COMPLETE: begin
                    if (ack) state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign counting = (state == COUNT);
    assign done = (state == COMPLETE);
    assign count = (state == COUNT) ? count_reg : 4'b0;

endmodule