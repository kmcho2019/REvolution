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
    localparam S_IDLE        = 3'b000;
    localparam S_PATTERN     = 3'b001;
    localparam S_CAPTURE     = 3'b010;
    localparam S_COUNTING    = 3'b011;
    localparam S_WAIT_ACK    = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [2:0] bit_count;
    reg [15:0] cycle_counter;
    reg [3:0] delay_value;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            bit_count <= 0;
            cycle_counter <= 0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            delay_value <= 4'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    // Shift in data and check for full pattern
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= S_CAPTURE;
                        bit_count <= 0;
                    end
                    counting <= 0;
                    done <= 0;
                end

                S_CAPTURE: begin
                    // Capture 4-bit delay value MSB first
                    delay_reg <= {delay_reg[2:0], data};
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == 3) begin
                        delay_value <= delay_reg;
                        // Initialize counter: (delay+1)*1000 cycles
                        cycle_counter <= ({delay_reg[2:0], data} + 1) * 1000 - 1;
                        count <= {delay_reg[2:0], data};
                        state <= S_COUNTING;
                        counting <= 1;
                    end
                end

                S_COUNTING: begin
                    if (cycle_counter == 0) begin
                        state <= S_WAIT_ACK;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        cycle_counter <= cycle_counter - 1;
                        // Update count every 1000 cycles
                        if (cycle_counter % 1000 == 0) begin
                            count <= count - 1;
                        end
                    end
                end

                S_WAIT_ACK: begin
                    if (ack) begin
                        state <= S_IDLE;
                        done <= 0;
                        pattern_reg <= 4'b0;
                    end
                end

                default: state <= S_IDLE;
            endcase
        end
    end

endmodule