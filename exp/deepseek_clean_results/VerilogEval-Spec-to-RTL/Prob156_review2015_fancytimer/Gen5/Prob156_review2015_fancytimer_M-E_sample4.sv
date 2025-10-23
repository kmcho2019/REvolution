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
        CAPTURE_DELAY,
        COUNT,
        DONE
    } state_t;

    reg [7:0] shift_reg;  // Stores both pattern and delay
    reg [3:0] delay_val;
    reg [9:0] prescaler;  // Counts to 1000
    reg [3:0] downcounter;
    state_t state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            shift_reg <= 8'b0;
            counting <= 0;
            done <= 0;
            count <= 4'b0;
            prescaler <= 0;
        end else begin
            case (state)
                IDLE: begin
                    shift_reg <= {shift_reg[6:0], data};
                    counting <= 0;
                    done <= 0;
                    
                    // Detect 1101 in upper 4 bits
                    if (shift_reg[7:4] == 4'b1101) begin
                        state <= CAPTURE_DELAY;
                    end
                end

                CAPTURE_DELAY: begin
                    shift_reg <= {shift_reg[6:0], data};
                    
                    // After 4 more bits, we have complete delay
                    if (&shift_reg[3:0]) begin
                        delay_val <= shift_reg[3:0];
                        downcounter <= shift_reg[3:0];
                        prescaler <= 0;
                        state <= COUNT;
                        counting <= 1;
                    end
                end

                COUNT: begin
                    if (prescaler == 999) begin
                        prescaler <= 0;
                        if (downcounter == 0) begin
                            state <= DONE;
                            counting <= 0;
                            done <= 1;
                        end else begin
                            downcounter <= downcounter - 1;
                        end
                    end else begin
                        prescaler <= prescaler + 1;
                    end
                    count <= downcounter;
                end

                DONE: begin
                    if (ack) begin
                        state <= IDLE;
                        shift_reg <= 8'b0;
                        done <= 0;
                    end
                end
            endcase
        end
    end

endmodule