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
    reg [3:0] delay_val;
    reg [2:0] bit_counter;
    reg [15:0] cycle_counter;
    reg [15:0] total_cycles;

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
                    
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_counter <= 3'd4;
                    end
                end

                CAPTURE: begin
                    delay_val <= {delay_val[2:0], data};
                    bit_counter <= bit_counter - 1;
                    
                    if (bit_counter == 1) begin
                        state <= COUNTING;
                        counting <= 1'b1;
                        total_cycles <= (delay_val + 1) * 1000;
                        cycle_counter <= total_cycles - 1;
                        count <= delay_val;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 0) begin
                        state <= DONE;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
                        // Update count every 1000 cycles
                        if (cycle_counter % 1000 == 0) begin
                            count <= count - 1;
                        end
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