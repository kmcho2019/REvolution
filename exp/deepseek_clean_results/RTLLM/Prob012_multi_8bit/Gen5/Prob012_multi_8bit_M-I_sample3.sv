module multi_8bit(
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    reg [2:0] bit_counter;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    
    typedef enum {IDLE, CALC, DONE} state_t;
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
                    bit_counter <= 3'b0;
                    done <= 1'b0;
                    state <= CALC;
                end
                
                CALC: begin
                    if (multiplier[bit_counter]) begin
                        accumulator <= accumulator + (multiplicand << bit_counter);
                    end
                    
                    if (bit_counter == 3'd7) begin
                        state <= DONE;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end
                
                DONE: begin
                    product <= accumulator;
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

    // Clock gating for power optimization
    wire gated_clk = clk & (state == CALC);
    always @(posedge gated_clk) begin
        // Main calculation happens here with gated clock
    end

endmodule