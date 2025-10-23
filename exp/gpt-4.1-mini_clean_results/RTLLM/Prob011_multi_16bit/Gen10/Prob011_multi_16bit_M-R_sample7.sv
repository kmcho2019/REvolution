module multi_16bit (
    input          clk,
    input          rst_n,
    input          start,
    input  [15:0]  ain,
    input  [15:0]  bin,
    output [31:0]  yout,
    output         done
);

    // States for FSM
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        BUSY = 2'b01
    } state_t;

    state_t state, next_state;

    reg [4:0] count;           // Count from 0 to 16
    reg [31:0] product;        // Accumulator for product
    reg [15:0] multiplicand;   // Multiplicand register
    reg [15:0] multiplier;     // Multiplier register
    reg done_r;

    // FSM state register
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = (start) ? BUSY : IDLE;
            BUSY: next_state = (count == 5'd16) ? IDLE : BUSY;
            default: next_state = IDLE;
        endcase
    end

    // Counter logic with enable
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            count <= 5'd0;
        else if (state == IDLE)
            count <= 5'd0;
        else if (state == BUSY)
            count <= count + 5'd1;
    end

    // Registers update with enables
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            multiplicand <= 16'd0;
            multiplier <= 16'd0;
            product <= 32'd0;
            done_r <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done_r <= 1'b0;
                    if (start) begin
                        multiplicand <= ain;
                        multiplier <= bin;
                        product <= 32'd0;
                    end
                end

                BUSY: begin
                    // If LSB of multiplier is 1, add multiplicand shifted by count to product
                    if (multiplier[0])
                        product <= product + ( {16'd0, multiplicand} << count );
                    // Shift multiplier right by 1
                    multiplier <= multiplier >> 1;

                    if (count == 5'd15)
                        done_r <= 1'b1;
                end
            endcase
        end
    end

    assign yout = product;
    assign done = done_r;

endmodule