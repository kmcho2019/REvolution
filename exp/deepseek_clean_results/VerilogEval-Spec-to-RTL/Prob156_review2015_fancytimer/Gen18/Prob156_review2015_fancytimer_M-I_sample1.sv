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
    localparam IDLE     = 3'b000;
    localparam CAPTURE  = 3'b001;
    localparam COUNTING = 3'b010;
    localparam DONE     = 3'b100;

    reg [2:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_value;
    reg [15:0] cycle_counter;
    reg [2:0] bit_counter;

    // Pattern detection and delay capture
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
            delay_value <= 4'b0;
            bit_counter <= 3'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_counter <= 3'b0;
                    end
                end
                
                CAPTURE: begin
                    if (bit_counter < 4) begin
                        delay_value <= {delay_value[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                    if (bit_counter == 3) begin
                        state <= COUNTING;
                        cycle_counter <= 0;
                        count <= delay_value;
                    end
                end
                
                COUNTING: begin
                    if (cycle_counter == (delay_value + 1) * 1000 - 1) begin
                        state <= DONE;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                        // Update count every 1000 cycles
                        if (cycle_counter % 1000 == 999) begin
                            count <= count - 1;
                        end
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

    // Output assignments
    always @(*) begin
        counting = (state == COUNTING);
        done = (state == DONE);
        if (state != COUNTING) begin
            count = 4'b0; // Don't-care when not counting
        end
    end

endmodule