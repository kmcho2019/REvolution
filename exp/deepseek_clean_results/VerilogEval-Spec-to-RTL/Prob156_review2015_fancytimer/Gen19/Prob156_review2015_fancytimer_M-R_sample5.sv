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
    localparam IDLE     = 2'b00;
    localparam CAPTURE = 2'b01;
    localparam COUNT   = 2'b10;
    localparam DONE    = 2'b11;

    reg [1:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [15:0] cycle_counter;
    reg [1:0] bit_counter;
    reg [3:0] count_reg;

    // Pattern detection
    always @(posedge clk) begin
        if (reset) begin
            pattern_reg <= 4'b0;
        end else if (state == IDLE) begin
            pattern_reg <= {pattern_reg[2:0], data};
        end
    end

    // State machine and delay capture
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            delay_reg <= 4'b0;
            bit_counter <= 2'b0;
            cycle_counter <= 16'b0;
            count_reg <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                        bit_counter <= 2'b0;
                    end
                end

                CAPTURE: begin
                    if (bit_counter < 3) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end else begin
                        // Capture last bit and transition
                        delay_reg <= {delay_reg[2:0], data};
                        state <= COUNT;
                        cycle_counter <= 16'b0;
                        count_reg <= delay_reg;
                    end
                end

                COUNT: begin
                    if (cycle_counter == (delay_reg + 1) * 1000 - 1) begin
                        state <= DONE;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                        // Update count every 1000 cycles
                        if (cycle_counter % 1000 == 999) begin
                            count_reg <= count_reg - 1;
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

    // Output assignments
    assign counting = (state == COUNT);
    assign done = (state == DONE);
    assign count = (state == COUNT) ? count_reg : 4'b0;

endmodule