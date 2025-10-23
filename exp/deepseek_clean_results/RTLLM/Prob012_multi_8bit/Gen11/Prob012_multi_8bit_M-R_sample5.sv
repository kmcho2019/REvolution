module multi_8bit(
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

    // State machine states
    typedef enum logic [1:0] {
        IDLE,
        CALCULATE,
        DONE
    } state_t;

    state_t current_state, next_state;

    // State register
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = start ? CALCULATE : IDLE;
            CALCULATE: next_state = (bit_counter == 3'd7) ? DONE : CALCULATE;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            accumulator <= 16'b0;
            multiplicand <= 8'b0;
            multiplier <= 8'b0;
            bit_counter <= 3'b0;
            product <= 16'b0;
            done <= 1'b0;
        end else begin
            case (current_state)
                IDLE: begin
                    if (start) begin
                        multiplicand <= A;
                        multiplier <= B;
                        accumulator <= 16'b0;
                        bit_counter <= 3'b0;
                        done <= 1'b0;
                    end
                end

                CALCULATE: begin
                    if (multiplier[0]) begin
                        accumulator <= accumulator + {8'b0, multiplicand};
                    end
                    multiplicand <= multiplicand << 1;
                    multiplier <= multiplier >> 1;
                    bit_counter <= bit_counter + 1;
                end

                DONE: begin
                    product <= accumulator;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule