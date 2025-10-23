module multi_16bit (
    input          clk,
    input          rst_n,   // active low synchronous reset
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output reg [31:0] yout,
    output reg     done
);

    // FSM states
    typedef enum reg [1:0] {IDLE=2'b00, BUSY=2'b01, DONE=2'b10} state_t;
    reg [1:0] state, next_state;

    reg [4:0] count;        // Counts from 0 to 16 (16 bits)
    reg [31:0] multiplicand; // 32-bit aligned multiplicand (ain shifted left 16)
    reg [15:0] multiplier;  // 16-bit multiplier register (bin shifted right each cycle)
    reg [31:0] product;     // Accumulator

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case(state)
            IDLE:
                if (start) next_state = BUSY;
                else next_state = IDLE;
            BUSY:
                if (count == 5'd16) next_state = DONE;
                else next_state = BUSY;
            DONE:
                if (!start) next_state = IDLE;
                else next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // Main control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 5'd0;
            multiplicand <= 32'd0;
            multiplier <= 16'd0;
            product <= 32'd0;
            yout <= 32'd0;
            done <= 1'b0;
        end else begin
            case(state)
                IDLE: begin
                    done <= 1'b0;
                    yout <= 32'd0;
                    count <= 5'd0;
                    if (start) begin
                        multiplicand <= {ain, 16'd0}; // align multiplicand to upper half (ain * 2^16)
                        multiplier <= bin;
                        product <= 32'd0;
                    end
                end
                BUSY: begin
                    // If LSB of multiplier is 1, add multiplicand shifted right by count to product
                    // Actually multiplicand is fixed, multiplier shifts right, so add multiplicand shifted right by count or simply add multiplicand shifted right count times
                    // But to save shifting multiplicand every cycle, we add multiplicand shifted right by 0 and shift product instead.
                    // Instead, shift multiplicand right by count each cycle. But to avoid that, we can shift multiplicand right by count by shifting multiplicand each time or shifting multiplicand once at start and shifting product.
                    // It's simpler to shift multiplicand right by count each cycle here.
                    // Since multiplicand is ain << 16, shifting right by count means multiplying ain by 2^(16 - count).
                    // To avoid shifting multiplicand repeatedly, we will shift the addition operand each cycle.
                    // Note: Multiplying by shifting is equivalent to adding partial products.

                    // But to optimize, shift multiplicand right by count before addition (logical shift right)
                    // and only add if multiplier LSB is 1

                    if (multiplier[0]) 
                        product <= product + (multiplicand >> count);
                    else
                        product <= product;

                    multiplier <= multiplier >> 1;
                    count <= count + 5'd1;
                end
                DONE: begin
                    done <= 1'b1;
                    yout <= product;
                    if (!start) begin
                        done <= 1'b0;
                        yout <= product;
                    end
                end
            endcase
        end
    end

endmodule