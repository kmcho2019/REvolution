module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output         done
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        LOAD = 2'd1,
        CALC = 2'd2
    } state_t;

    state_t state, next_state;

    reg [4:0] count;            // count from 0 to 16 for shift steps
    reg [15:0] multiplicand;    // holds ain
    reg [15:0] multiplier;      // holds bin shifted right each cycle
    reg [31:0] product_accum;   // accumulates partial sums

    reg done_r;

    // State transition logic
    always @(*) begin
        case (state)
            IDLE:  next_state = (start) ? LOAD : IDLE;
            LOAD:  next_state = CALC;
            CALC:  next_state = (count == 5'd16) ? IDLE : CALC;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic for state, count and registers
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state        <= IDLE;
            count        <= 5'd0;
            multiplicand <= 16'd0;
            multiplier   <= 16'd0;
            product_accum<= 32'd0;
            yout         <= 32'd0;
            done_r       <= 1'b0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    done_r <= 1'b0;
                    yout   <= 32'd0;
                    count  <= 5'd0;
                    if (start) begin
                        multiplicand <= ain;
                        multiplier   <= bin;
                        product_accum<= 32'd0;
                    end
                end

                LOAD: begin
                    // Inputs latched in previous cycle; move to CALC next
                    // No changes needed here, except count reset
                    count <= 5'd0;
                end

                CALC: begin
                    // Shift count increments
                    count <= count + 5'd1;

                    // If LSB of multiplier is 1, add multiplicand shifted by current count to accumulator
                    if (multiplier[0])
                        product_accum <= product_accum + ({16'd0, multiplicand} << count);

                    // Shift multiplier right by 1
                    multiplier <= multiplier >> 1;

                    if (count == 5'd15) begin
                        yout <= product_accum;
                        done_r <= 1'b1;
                    end
                end
            endcase
        end
    end

    assign done = done_r;

endmodule