module multi_8bit (
    input clk,
    input reset,
    input start,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    reg [2:0] bit_counter;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    
    typedef enum {IDLE, RUNNING} state_t;
    reg state;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            product <= 16'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= A;
                        multiplier <= B;
                        accumulator <= 16'b0;
                        bit_counter <= 3'b0;
                        done <= 1'b0;
                        state <= RUNNING;
                    end
                end
                
                RUNNING: begin
                    if (multiplier[bit_counter]) begin
                        accumulator <= accumulator + (multiplicand << bit_counter);
                    end
                    
                    bit_counter <= bit_counter + 1;
                    
                    if (&bit_counter) begin  // When counter reaches 7
                        product <= accumulator;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule