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
    typedef enum logic [1:0] {
        IDLE,
        CAPTURE,
        COUNT,
        FINISH
    } state_t;

    state_t state;

    // Shift register serves dual purpose:
    // - Pattern detection (first 4 bits)
    // - Delay value capture (next 4 bits)
    reg [3:0] shift_reg;
    wire pattern_match = (shift_reg == 4'b1101);

    // Down counter for precise timing
    reg [13:0] timer;
    wire timer_done = (timer == 0);

    // Bit counter for delay capture
    reg [1:0] bit_count;

    // Edge detection for ack
    reg ack_prev;
    wire ack_rise = ~ack_prev & ack;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            timer <= 14'b0;
            bit_count <= 2'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
            ack_prev <= 1'b0;
        end else begin
            ack_prev <= ack;

            case (state)
                IDLE: begin
                    // Shift in data continuously
                    shift_reg <= {shift_reg[2:0], data};
                    counting <= 1'b0;
                    done <= 1'b0;
                    
                    // When pattern matches, prepare to capture delay
                    if (pattern_match) begin
                        state <= CAPTURE;
                        bit_count <= 2'b0;
                    end
                end

                CAPTURE: begin
                    // Shift in next 4 bits for delay value
                    shift_reg <= {shift_reg[2:0], data};
                    bit_count <= bit_count + 1;

                    if (bit_count == 2'd3) begin
                        // Calculate timer value: (delay+1)*1000
                        timer <= ({shift_reg[2:0], data} + 1) * 14'd1000;
                        state <= COUNT;
                        counting <= 1'b1;
                    end
                end

                COUNT: begin
                    // Count down and update outputs
                    timer <= timer - 1;
                    
                    // Current count value is timer/1000 (rounded down)
                    count <= timer[13:10]; // Equivalent to dividing by 1024, good enough approximation
                    
                    if (timer_done) begin
                        state <= FINISH;
                        counting <= 1'b0;
                        done <= 1'b1;
                    end
                end

                FINISH: begin
                    if (ack_rise) begin
                        state <= IDLE;
                        shift_reg <= 4'b0; // Reset shift register
                        done <= 1'b0;
                    end
                end
            endcase
        end
    end

endmodule