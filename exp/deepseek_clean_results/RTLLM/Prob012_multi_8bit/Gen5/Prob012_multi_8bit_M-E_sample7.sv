module multi_8bit (
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    reg [2:0] count;
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;

    // FSM states
    typedef enum {IDLE, CALC, FINISH} state_t;
    state_t current_state, next_state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
            accumulator <= 16'b0;
            multiplicand <= 8'b0;
            multiplier <= 8'b0;
            count <= 3'b0;
            done <= 1'b0;
        end else begin
            current_state <= next_state;

            case (current_state)
                IDLE: begin
                    if (reset == 1'b0) begin
                        multiplicand <= A;
                        multiplier <= B;
                        accumulator <= 16'b0;
                        count <= 3'b0;
                        done <= 1'b0;
                    end
                end

                CALC: begin
                    if (multiplier[0]) begin
                        accumulator <= accumulator + {8'b0, multiplicand};
                    end
                    multiplicand <= multiplicand << 1;
                    multiplier <= multiplier >> 1;
                    count <= count + 1;
                end

                FINISH: begin
                    product <= accumulator;
                    done <= 1'b1;
                end
            endcase
        end
    end

    always @(*) begin
        case (current_state)
            IDLE: next_state = CALC;
            CALC: next_state = (count == 3'd7) ? FINISH : CALC;
            FINISH: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule