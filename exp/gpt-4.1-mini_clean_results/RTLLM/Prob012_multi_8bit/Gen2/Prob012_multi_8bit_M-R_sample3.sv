module multi_8bit (
    input         clk,
    input         rst_n,
    input  [7:0]  A,
    input  [7:0]  B,
    output reg [15:0] product,
    output reg        done
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] acc;
    reg [3:0] bit_pos;  // to count 0 to 7

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    // Sequential FSM state update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            product <= 16'd0;
            done <= 1'b0;
            acc <= 16'd0;
            multiplicand <= 8'd0;
            multiplier <= 8'd0;
            bit_pos <= 4'd0;
        end else begin
            state <= next_state;
            if (state == IDLE) begin
                acc <= 16'd0;
                multiplicand <= A;
                multiplier <= B;
                bit_pos <= 4'd0;
                done <= 1'b0;
            end else if (state == CALC) begin
                // Shift and add if current bit set
                if (multiplier[bit_pos])
                    acc <= acc + (multiplicand << bit_pos);
                bit_pos <= bit_pos + 1;
            end else if (state == DONE) begin
                product <= acc;
                done <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = CALC;
            CALC:   next_state = (bit_pos == 4'd8) ? DONE : CALC;
            DONE:   next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

endmodule