module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output counting,
    output done,
    input ack
);

    // State encoding
    localparam IDLE  = 2'b00;
    localparam LOAD  = 2'b01;
    localparam COUNT = 2'b10;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_val;
    reg [2:0] load_count;
    reg [13:0] main_counter; // Enough for 15*1000=15000 cycles
    reg done_reg;

    // Continuous outputs
    assign counting = (state == COUNT);
    assign done = done_reg;

    // Pattern detection shift register
    always @(posedge clk) begin
        if (reset || (state == COUNT))
            pattern_reg <= 4'b0;
        else if (state == IDLE)
            pattern_reg <= {pattern_reg[2:0], data};
    end

    // Main state machine and counters
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay_val <= 4'b0;
            load_count <= 0;
            main_counter <= 0;
            count <= 4'b0;
            done_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    done_reg <= 0;
                    if (pattern_reg == 4'b1101) begin
                        state <= LOAD;
                        load_count <= 0;
                    end
                end

                LOAD: begin
                    if (load_count < 4) begin
                        delay_val <= {delay_val[2:0], data};
                        load_count <= load_count + 1;
                    end else begin
                        state <= COUNT;
                        main_counter <= (delay_val + 1) * 1000 - 1;
                    end
                end

                COUNT: begin
                    if (main_counter > 0) begin
                        main_counter <= main_counter - 1;
                        // Update count output based on remaining time
                        count <= (main_counter - 1) / 1000;
                    end else begin
                        done_reg <= 1;
                        if (ack) begin
                            state <= IDLE;
                            done_reg <= 0;
                        end
                    end
                end
            endcase
        end
    end

endmodule