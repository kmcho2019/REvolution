module multi_8bit (
    input clk,
    input reset,
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product,
    output reg done
);

    // FSM states
    typedef enum {IDLE, MULTIPLY, DONE} state_t;
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

    // FSM next state logic
    always @(*) begin
        case (current_state)
            IDLE: next_state = MULTIPLY;
            MULTIPLY: next_state = (bit_counter == 3'd7) ? DONE : MULTIPLY;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                multiplicand <= A;
                multiplier <= B;
                accumulator <= 16'b0;
                bit_counter <= 3'b0;
                done <= 1'b0;
            end
            MULTIPLY: begin
                if (multiplier[bit_counter]) begin
                    accumulator <= accumulator + {8'b0, multiplicand};
                end
                multiplicand <= multiplicand << 1;
                bit_counter <= bit_counter + 1;
            end
            DONE: begin
                product <= accumulator;
                done <= 1'b1;
            end
        endcase
    end

endmodule