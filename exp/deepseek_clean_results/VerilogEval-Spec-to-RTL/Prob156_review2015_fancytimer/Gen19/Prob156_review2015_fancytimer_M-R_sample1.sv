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
    localparam IDLE     = 4'b0001;
    localparam CAPTURE  = 4'b0010;
    localparam COUNTING = 4'b0100;
    localparam DONE     = 4'b1000;

    reg [3:0] state;
    reg [3:0] pattern_reg;
    reg [3:0] delay_reg;
    reg [9:0] cycle_counter;  // Counts 0-999 for each 1000-cycle interval
    reg [3:0] remaining_time;
    reg [2:0] bit_counter;

    // Continuous assignments for outputs
    assign count = (state == COUNTING) ? remaining_time : 4'b0;
    assign counting = (state == COUNTING);
    assign done = (state == DONE);

    // Pattern detection and state control
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            pattern_reg <= 4'b0;
        end else begin
            case (state)
                IDLE: begin
                    pattern_reg <= {pattern_reg[2:0], data};
                    if (pattern_reg == 4'b1101) begin
                        state <= CAPTURE;
                    end
                end

                CAPTURE: begin
                    if (bit_counter == 3'b100) begin
                        state <= COUNTING;
                    end
                end

                COUNTING: begin
                    if (remaining_time == 0 && cycle_counter == 10'd999) begin
                        state <= DONE;
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

    // Delay capture and counting logic
    always @(posedge clk) begin
        if (reset) begin
            delay_reg <= 4'b0;
            bit_counter <= 3'b0;
            cycle_counter <= 10'b0;
            remaining_time <= 4'b0;
        end else begin
            case (state)
                CAPTURE: begin
                    if (bit_counter < 3'b100) begin
                        delay_reg <= {delay_reg[2:0], data};
                        bit_counter <= bit_counter + 1;
                    end
                end

                COUNTING: begin
                    if (cycle_counter == 10'd999) begin
                        cycle_counter <= 10'b0;
                        remaining_time <= remaining_time - 1;
                    end else begin
                        cycle_counter <= cycle_counter + 1;
                    end
                end

                IDLE: begin
                    bit_counter <= 3'b0;
                    cycle_counter <= 10'b0;
                    remaining_time <= 4'b0;
                end

                default: begin
                    // Other states maintain their values
                end
            endcase

            // Initialize remaining_time when entering COUNTING state
            if (state == CAPTURE && bit_counter == 3'b100) begin
                remaining_time <= delay_reg;
            end
        end
    end

endmodule