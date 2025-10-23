module multi_8bit (
    input clk,
    input reset,
    input start,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    reg [2:0] state;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [2:0] bit_counter;

    localparam IDLE = 0;
    localparam MULTIPLY = 1;
    localparam DONE = 2;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            product <= 0;
            done <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= A;
                        multiplier <= B;
                        accumulator <= 0;
                        bit_counter <= 0;
                        state <= MULTIPLY;
                        done <= 0;
                    end
                end
                
                MULTIPLY: begin
                    if (multiplier == 0) begin
                        state <= DONE;
                    end else begin
                        if (multiplier[0]) begin
                            accumulator <= accumulator + {8'b0, multiplicand};
                        end
                        multiplicand <= multiplicand << 1;
                        multiplier <= multiplier >> 1;
                        bit_counter <= bit_counter + 1;
                        
                        if (bit_counter == 7) begin
                            state <= DONE;
                        end
                    end
                end
                
                DONE: begin
                    product <= accumulator;
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule