module multi_8bit (
    input          clk,
    input          rst_n,
    input  [7:0]   A,
    input  [7:0]   B,
    input          start,
    output reg [15:0] product,
    output reg     done
);
    reg [7:0] multiplicand;
    reg [7:0] multiplier;
    reg [15:0] accumulator;
    reg [3:0] count;

    typedef enum logic [1:0] {
        IDLE,
        CALC,
        DONE
    } state_t;
    state_t state, next_state;

    // State register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:   next_state = start ? CALC : IDLE;
            CALC:   next_state = (count == 8) ? DONE : CALC;
            DONE:   next_state = start ? CALC : IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Main sequential logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 8'd0;
            multiplier   <= 8'd0;
            accumulator  <= 16'd0;
            count        <= 4'd0;
            product      <= 16'd0;
            done         <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 1'b0;
                    product <= 16'd0;
                    count <= 4'd0;
                    if (start) begin
                        multiplicand <= A;
                        multiplier <= B;
                        accumulator <= 16'd0;
                    end
                end
                CALC: begin
                    // Check LSB of multiplier
                    if (multiplier[0] == 1'b1)
                        accumulator <= accumulator + {8'd0, multiplicand};
                    else
                        accumulator <= accumulator;

                    multiplier <= multiplier >> 1;
                    multiplicand <= multiplicand << 1;
                    count <= count + 1;
                end
                DONE: begin
                    product <= accumulator;
                    done <= 1'b1;
                end
            endcase
        end
    end

endmodule