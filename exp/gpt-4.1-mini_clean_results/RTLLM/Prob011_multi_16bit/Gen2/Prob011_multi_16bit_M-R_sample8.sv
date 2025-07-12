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

    reg [4:0] bit_count;         // counts from 0 to 16 for bits processed
    reg [31:0] product;          // accumulates partial sums
    reg [15:0] multiplicand;     // holds ain
    reg [31:0] multiplier_shift; // shifted multiplier (bin shifted left each cycle)

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
                if (bit_count == 5'd16)
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

    // Bit count register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bit_count <= 5'd0;
        else if (state == CALC)
            bit_count <= bit_count + 5'd1;
        else
            bit_count <= 5'd0;
    end

    // Registers update and shift-accumulate operation
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand    <= 16'd0;
            multiplier_shift <= 32'd0;
            product         <= 32'd0;
            yout            <= 32'd0;
            done            <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        multiplicand    <= ain;
                        // Initialize multiplier_shift to bin aligned at LSB of 32-bit reg
                        multiplier_shift <= {16'd0, bin};
                        product         <= 32'd0;
                    end
                end
                CALC: begin
                    // Check LSB of multiplicand to decide whether to add shifted multiplier
                    if (multiplicand[0])
                        product <= product + multiplier_shift;
                    else
                        product <= product;

                    // Shift multiplicand right by 1 to process next bit in next cycle
                    multiplicand <= multiplicand >> 1;
                    // Shift multiplier_shift left by 1 to align with next bit
                    multiplier_shift <= multiplier_shift << 1;
                end
                DONE: begin
                    done <= 1'b1;
                    yout <= product;
                end
            endcase
        end
    end

endmodule