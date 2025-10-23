module TopModule (
    input clk,
    input reset,
    input data,
    output reg [3:0] count,
    output reg counting,
    output reg done,
    input ack
);

    // States
    typedef enum {
        IDLE,
        GET_DELAY,
        COUNT,
        DONE
    } state_t;

    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [15:0] counter;  // Enough for max delay (15+1)*1000=16000 cycles
    state_t state;
    reg [1:0] bit_count;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            counter <= 0;
            bit_count <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                    
                    // Detect 1101 pattern
                    if (shift_reg == 4'b1101) begin
                        state <= GET_DELAY;
                        bit_count <= 0;
                    end
                end

                GET_DELAY: begin
                    shift_reg <= {shift_reg[2:0], data};
                    bit_count <= bit_count + 1;
                    
                    if (bit_count == 3) begin
                        delay <= shift_reg;
                        counter <= ({shift_reg, 10'b0} + {14'b0, shift_reg} * 4'b1000); // (delay+1)*1000
                        state <= COUNT;
                        counting <= 1;
                    end
                end

                COUNT: begin
                    if (counter == 0) begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end else begin
                        counter <= counter - 1;
                        // Update count output every 1000 cycles
                        if (counter % 1000 == 0) begin
                            count <= (counter / 1000) - 1;
                        end
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 4'b0;
                        done <= 0;
                        count <= 4'b0;
                    end
                end
            endcase
        end
    end

endmodule