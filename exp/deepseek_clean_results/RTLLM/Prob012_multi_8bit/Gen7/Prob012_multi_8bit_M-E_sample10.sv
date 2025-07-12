module multi_8bit(
    input clk,
    input rst_n,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    reg [2:0] bit_counter;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [1:0] state;

    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            product <= 16'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (A != multiplicand || B != multiplier) begin
                        multiplicand <= A;
                        multiplier <= B;
                        accumulator <= 16'b0;
                        bit_counter <= 3'b0;
                        state <= CALC;
                        done <= 1'b0;
                    end
                end

                CALC: begin
                    if (multiplier[bit_counter]) begin
                        accumulator <= accumulator + {8'b0, multiplicand} << bit_counter;
                    end

                    if (bit_counter == 3'd7) begin
                        state <= DONE;
                        product <= accumulator;
                        done <= 1'b1;
                    end else begin
                        bit_counter <= bit_counter + 1;
                    end
                end

                DONE: begin
                    if (A != multiplicand || B != multiplier) begin
                        state <= IDLE;
                    end
                end
            endcase
        end
    end

endmodule