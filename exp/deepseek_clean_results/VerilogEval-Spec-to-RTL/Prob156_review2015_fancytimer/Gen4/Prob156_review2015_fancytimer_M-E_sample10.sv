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
    localparam IDLE = 0;
    localparam CAPTURE_DELAY = 1;
    localparam COUNTING = 2;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [13:0] main_counter;
    reg [3:0] captured_delay;
    reg pattern_matched;

    // Parallel pattern detection (1101)
    always @(*) begin
        pattern_matched = (shift_reg == 4'b1101);
    end

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            main_counter <= 14'b0;
            captured_delay <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            // Shift register for both pattern and delay capture
            shift_reg <= {shift_reg[2:0], data};

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (pattern_matched) begin
                        state <= CAPTURE_DELAY;
                    end
                end

                CAPTURE_DELAY: begin
                    if (&shift_reg[3:0]) begin  // After 4 more bits
                        captured_delay <= shift_reg;
                        main_counter <= (shift_reg + 1) * 14'd1000 - 1;
                        state <= COUNTING;
                        counting <= 1'b1;
                    end
                end

                COUNTING: begin
                    if (main_counter == 14'b0) begin
                        counting <= 1'b0;
                        done <= 1'b1;
                        state <= IDLE;
                    end else begin
                        main_counter <= main_counter - 1;
                    end
                    // Calculate remaining intervals
                    count <= (main_counter / 1000);
                end
            endcase

            // Handle ack in any state
            if (done && ack) begin
                done <= 1'b0;
                shift_reg <= 4'b0;
            end
        end
    end

endmodule