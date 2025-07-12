module multi_8bit (
    input clk,
    input reset,
    input start,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    // FSM states
    typedef enum {IDLE, CHECK, ADD, SHIFT} state_t;
    state_t current_state, next_state;

    // Internal registers
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [2:0] bit_counter;

    // FSM state transition
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    // FSM logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = start ? CHECK : IDLE;
            CHECK: next_state = (multiplier[0]) ? ADD : SHIFT;
            ADD: next_state = SHIFT;
            SHIFT: next_state = (bit_counter == 7) ? IDLE : CHECK;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand <= 8'b0;
            multiplier <= 8'b0;
            accumulator <= 16'b0;
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
                CHECK: begin
                    // No operations, just checking multiplier[0]
                end
                ADD: begin
                    accumulator <= accumulator + {8'b0, multiplicand};
                end
                SHIFT: begin
                    multiplier <= multiplier >> 1;
                    multiplicand <= multiplicand << 1;
                    bit_counter <= bit_counter + 1;
                    if (bit_counter == 7) begin
                        product <= accumulator;
                        done <= 1'b1;
                    end
                end
            endcase
        end
    end

endmodule