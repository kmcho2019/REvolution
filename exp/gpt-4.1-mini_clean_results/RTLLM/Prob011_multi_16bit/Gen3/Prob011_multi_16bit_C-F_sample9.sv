module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0]  yout,
    output reg         done
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        CALC = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    reg [4:0] i;            // shift count (0 to 16)
    reg [15:0] areg;        // shifted multiplicand
    reg [31:0] breg;        // shifted multiplier extended to 32 bits
    reg [31:0] product;     // accumulated product

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // FSM next state logic
    always @(*) begin
        case(state)
            IDLE: begin
                if (start)
                    next_state = CALC;
                else
                    next_state = IDLE;
            end
            CALC: begin
                if (i == 5'd16)
                    next_state = DONE;
                else
                    next_state = CALC;
            end
            DONE: begin
                if (!start)
                    next_state = IDLE;
                else
                    next_state = DONE;
            end
            default: next_state = IDLE;
        endcase
    end

    // Shift count register update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            i <= 5'd0;
        else if (state == CALC)
            i <= i + 5'd1;
        else
            i <= 5'd0;
    end

    // Shift and accumulate operation and registers update
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg    <= 16'd0;
            breg    <= 32'd0;
            product <= 32'd0;
            yout    <= 32'd0;
            done    <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 1'b0;
                    yout <= 32'd0;
                    if (start) begin
                        areg    <= ain;
                        breg    <= {16'd0, bin};
                        product <= 32'd0;
                    end
                end
                CALC: begin
                    // If LSB of areg is 1, accumulate breg to product
                    if (areg[0])
                        product <= product + breg;
                    else
                        product <= product;

                    // Shift areg right by 1 to process next bit next cycle
                    areg <= areg >> 1;

                    // Shift breg left by 1 to align for next bit
                    breg <= breg << 1;
                end
                DONE: begin
                    done <= 1'b1;
                    yout <= product;
                end
                default: begin
                    // Defensive default assignments
                    areg    <= 16'd0;
                    breg    <= 32'd0;
                    product <= 32'd0;
                    yout    <= 32'd0;
                    done    <= 1'b0;
                end
            endcase
        end
    end

endmodule