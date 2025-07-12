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
    typedef enum logic [1:0] {
        IDLE,
        COUNTING,
        DONE
    } state_t;

    state_t state;

    // Pattern and delay capture
    reg [3:0] shift_reg;
    reg [3:0] delay;
    reg [13:0] counter; // Enough for 15*1000 = 15000 cycles
    reg [3:0] bits_captured;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 4'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            bits_captured <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[2:0], data};
                    counting <= 0;
                    done <= 0;
                    
                    if (shift_reg == 4'b1101 && bits_captured == 0) begin
                        bits_captured <= 1;
                    end else if (bits_captured > 0 && bits_captured < 5) begin
                        delay <= {delay[2:0], data};
                        bits_captured <= bits_captured + 1;
                    end
                    
                    if (bits_captured == 5) begin
                        state <= COUNTING;
                        counter <= (delay + 1) * 1000;
                        count <= delay;
                    end
                end

                COUNTING: begin
                    counting <= 1;
                    if (counter > 0) begin
                        counter <= counter - 1;
                        // Update count every 1000 cycles
                        if (counter % 1000 == 0) begin
                            count <= (counter / 1000) - 1;
                        end
                    end else begin
                        state <= DONE;
                        counting <= 0;
                        done <= 1;
                    end
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        done <= 0;
                        bits_captured <= 0;
                    end
                end
            endcase
        end
    end

endmodule