module multi_8bit (
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    // FSM states
    localparam IDLE  = 2'b00;
    localparam CHECK = 2'b01;
    localparam ADD   = 2'b10;
    localparam SHIFT = 2'b11;

    reg [1:0] state;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [2:0] bit_counter;

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
                    product <= 16'b0;
                    bit_counter <= 3'b0;
                    done <= 1'b0;
                    state <= CHECK;
                end

                CHECK: begin
                    if (bit_counter == 3'd7) begin
                        done <= 1'b1;
                        state <= IDLE;
                    end else if (multiplier[0]) begin
                        state <= ADD;
                    end else begin
                        state <= SHIFT;
                    end
                end

                ADD: begin
                    product <= product + {8'b0, multiplicand};
                    state <= SHIFT;
                end

                SHIFT: begin
                    multiplicand <= multiplicand << 1;
                    multiplier <= multiplier >> 1;
                    bit_counter <= bit_counter + 1;
                    state <= CHECK;
                end
            endcase
        end
    end

endmodule