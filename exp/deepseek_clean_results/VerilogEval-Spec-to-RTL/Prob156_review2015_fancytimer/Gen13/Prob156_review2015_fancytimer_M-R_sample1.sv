module TopModule (
    input clk,
    input reset,
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack
);

    // One-hot encoded states
    localparam IDLE     = 4'b0001;
    localparam CAPTURE  = 4'b0010;
    localparam COUNTING = 4'b0100;
    localparam DONE     = 4'b1000;

    reg [3:0] state;
    reg [3:0] pattern_reg;    // For 1101 detection
    reg [3:0] delay_reg;      // For delay value capture
    reg [9:0] cycle_counter;  // Counts 0-999
    reg [3:0] period_counter; // Counts delay periods
    reg [1:0] bit_counter;    // For capture state

    // Continuous assignments for outputs
    assign count = (state == COUNTING) ? period_counter : 4'b0;
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
            delay_reg <= 4'b0;
            cycle_counter <= 0;
            period_counter <= 0;
            bit_counter <= 0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    // Only check after full pattern is shifted in
                    if (&pattern_reg[3:1] & ~pattern_reg[0]) begin
                        if (pattern_reg == 4'b1101) begin
                            state <= CAPTURE;
                            bit_counter <= 0;
                        end
                    end
                end

                CAPTURE: begin
                    if (bit_counter == 3) begin
                        delay_reg <= {delay_reg[2:0], data};
                        state <= COUNTING;
                        cycle_counter <= 0;
                        period_counter <= delay_reg[3:0];
                    end else begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 999) begin
                        cycle_counter <= 0;
                        if (period_counter == 0) begin
                            state <= DONE;
                        end else begin
                            period_counter <= period_counter - 1;
                        end
                    end else begin
                        cycle_counter <= cycle_counter + 1;
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