module multi_8bit (
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [3:0] bit_counter;
    
    typedef enum {IDLE, RUNNING, FINISH} state_t;
    state_t state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            product <= 16'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    multiplicand <= A;
                    multiplier <= B;
                    accumulator <= 16'b0;
                    bit_counter <= 4'd0;
                    done <= 1'b0;
                    state <= RUNNING;
                end
                
                RUNNING: begin
                    if (multiplier == 8'b0) begin
                        // Early termination if remaining bits are zero
                        product <= accumulator;
                        done <= 1'b1;
                        state <= FINISH;
                    end else begin
                        if (multiplier[0]) begin
                            accumulator <= accumulator + {8'b0, multiplicand};
                        end
                        
                        // Prepare for next bit
                        multiplicand <= multiplicand << 1;
                        multiplier <= multiplier >> 1;
                        bit_counter <= bit_counter + 1;
                        
                        if (bit_counter == 4'd7) begin
                            product <= accumulator;
                            done <= 1'b1;
                            state <= FINISH;
                        end
                    end
                end
                
                FINISH: begin
                    // Hold output until new calculation
                    if (!done) state <= IDLE;
                end
            endcase
        end
    end

endmodule