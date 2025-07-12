module multi_8bit(
    input clk,
    input start,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE,
        INIT,
        CALC,
        FINISH
    } state_t;

    // Internal registers
    reg [1:0] state;
    reg [7:0] multiplier;
    reg [15:0] multiplicand;
    reg [2:0] bit_counter;

    // FSM control
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                done <= 1'b0;
                if (start) begin
                    state <= INIT;
                end
            end
            
            INIT: begin
                multiplicand <= {8'b0, A};
                multiplier <= B;
                product <= 16'b0;
                bit_counter <= 3'b0;
                state <= CALC;
            end
            
            CALC: begin
                if (multiplier[0]) begin
                    product <= product + multiplicand;
                end
                
                multiplicand <= multiplicand << 1;
                multiplier <= multiplier >> 1;
                bit_counter <= bit_counter + 1;
                
                if (bit_counter == 3'd7) begin
                    state <= FINISH;
                end
            end
            
            FINISH: begin
                done <= 1'b1;
                state <= IDLE;
            end
        endcase
    end

endmodule