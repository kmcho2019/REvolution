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
    localparam PATTERN_MATCH = 1;
    localparam CAPTURE_DELAY = 2;
    localparam COUNTING = 3;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [15:0] main_counter;  // Increased to handle max value (16*1000=16000)
    reg [3:0] captured_delay;
    reg [1:0] delay_bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            main_counter <= 16'b0;
            captured_delay <= 4'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
            delay_bit_count <= 2'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    counting <= 1'b0;
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= PATTERN_MATCH;
                    end
                end

                PATTERN_MATCH: begin
                    // Reset shift reg to capture delay bits
                    shift_reg <= 4'b0;
                    delay_bit_count <= 2'b0;
                    state <= CAPTURE_DELAY;
                end

                CAPTURE_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    delay_bit_count <= delay_bit_count + 1;
                    
                    if (delay_bit_count == 2'b11) begin  // After 4 bits
                        captured_delay <= shift_reg;
                        main_counter <= (shift_reg + 1) * 16'd1000;
                        state <= COUNTING;
                        counting <= 1'b1;
                    end
                end

                COUNTING: begin
                    if (main_counter > 0) begin
                        main_counter <= main_counter - 1;
                        // Calculate remaining intervals
                        count <= (main_counter - 1) / 1000;
                    end else begin
                        counting <= 1'b0;
                        done <= 1'b1;
                        count <= 4'b0;  // Don't-care when not counting
                    end

                    if (done && ack) begin
                        state <= IDLE;
                        shift_reg <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule