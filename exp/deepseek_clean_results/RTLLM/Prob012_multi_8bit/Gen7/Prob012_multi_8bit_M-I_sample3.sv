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
    
    localparam IDLE = 1'b0;
    localparam PROCESSING = 1'b1;
    reg state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            done <= 1'b0;
            product <= 16'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= A;
                        multiplier <= B;
                        accumulator <= 16'b0;
                        bit_counter <= 3'b0;
                        done <= 1'b0;
                        state <= PROCESSING;
                    end
                end
                
                PROCESSING: begin
                    // Add shifted multiplicand if current bit is set
                    if (multiplier[0]) begin
                        accumulator <= accumulator + {8'b0, multiplicand};
                    end
                    
                    // Shift multiplicand left and multiplier right
                    multiplicand <= multiplicand << 1;
                    multiplier <= multiplier >> 1;
                    
                    // Increment bit counter
                    bit_counter <= bit_counter + 1;
                    
                    // Check for completion
                    if (bit_counter == 3'd7) begin
                        product <= accumulator;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                    
                    // Early termination if remaining bits are zero
                    if (multiplier == 8'b0) begin
                        product <= accumulator;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule