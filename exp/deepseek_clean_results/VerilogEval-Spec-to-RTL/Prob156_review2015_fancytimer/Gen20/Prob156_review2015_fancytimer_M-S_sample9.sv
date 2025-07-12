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
    localparam [1:0]
        S_IDLE      = 2'b00,
        S_CAPTURE   = 2'b01,
        S_COUNTING  = 2'b10,
        S_DONE      = 2'b11;

    reg [1:0] state;
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [13:0] timer; // Enough for (15+1)*1000=16000 cycles
    reg [1:0] bit_cnt;

    // Pattern detection and shift register
    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            shift_reg <= 4'b0;
            delay <= 4'b0;
            timer <= 14'b0;
            bit_cnt <= 2'b0;
            counting <= 1'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                S_IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    if (shift_reg == 4'b1101) begin
                        state <= S_CAPTURE;
                        bit_cnt <= 2'b0;
                    end
                end

                S_CAPTURE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_cnt <= bit_cnt + 1;
                    if (bit_cnt == 2'b11) begin
                        delay <= shift_reg;
                        state <= S_COUNTING;
                        timer <= {shift_reg, 10'b0} + {4'b0, shift_reg, 6'b0} + 14'd1000;
                    end
                end

                S_COUNTING: begin
                    if (timer == 14'b1) begin
                        state <= S_DONE;
                    end else begin
                        timer <= timer - 1;
                    end
                    // Update count output every 1000 cycles
                    count <= (timer - 1) / 1000;
                end

                S_DONE: begin
                    if (ack) begin
                        state <= S_IDLE;
                        shift_reg <= 4'b0;
                    end
                end
            endcase

            // Output logic
            counting <= (state == S_COUNTING);
            done <= (state == S_DONE);
        end
    end

endmodule