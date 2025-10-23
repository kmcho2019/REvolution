module multi_8bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [7:0]   A,
    input  [7:0]   B,
    output reg [15:0] product,
    output reg     done
);

    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [3:0] count; // counts 0 to 8

    typedef enum logic [1:0] {IDLE, RUN, DONE} state_t;
    state_t state, next_state;

    // State machine sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            product <= 16'd0;
            done <= 1'b0;
            multiplicand <= 8'd0;
            multiplier <= 8'd0;
            accumulator <= 16'd0;
            count <= 4'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand <= A;
                        multiplier <= B;
                        accumulator <= 16'd0;
                        count <= 4'd0;
                    end
                end
                RUN: begin
                    // If LSB of multiplier is 1, add multiplicand to accumulator
                    if (multiplier[0])
                        accumulator <= accumulator + {8'd0, multiplicand};
                    else
                        accumulator <= accumulator;

                    multiplicand <= multiplicand << 1;
                    multiplier <= multiplier >> 1;
                    count <= count + 1;
                end
                DONE: begin
                    product <= accumulator;
                    done <= 1'b1;
                end
            endcase
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:    next_state = start ? RUN : IDLE;
            RUN:     next_state = (count == 4'd8) ? DONE : RUN;
            DONE:    next_state = start ? RUN : IDLE;
            default: next_state = IDLE;
        endcase
    end

endmodule