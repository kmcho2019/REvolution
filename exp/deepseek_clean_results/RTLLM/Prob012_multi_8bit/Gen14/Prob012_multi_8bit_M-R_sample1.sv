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
    reg [15:0] accumulator;
    reg state;

    localparam IDLE = 1'b0;
    localparam MULTIPLY = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            product <= 16'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (B != 8'b0) begin  // Start multiplication when inputs are ready
                        multiplicand <= A;
                        accumulator <= 16'b0;
                        bit_counter <= 3'b0;
                        state <= MULTIPLY;
                        done <= 1'b0;
                    end
                end
                
                MULTIPLY: begin
                    if (bit_counter == 3'd7) begin
                        // Final result
                        product <= accumulator + (B[bit_counter] ? {multiplicand, 7'b0} : 16'b0);
                        state <= IDLE;
                        done <= 1'b1;
                    end else begin
                        // Shift-and-add step
                        accumulator <= accumulator + (B[bit_counter] ? {8'b0, multiplicand} << bit_counter : 16'b0);
                        bit_counter <= bit_counter + 1;
                    end
                end
            endcase
        end
    end

endmodule