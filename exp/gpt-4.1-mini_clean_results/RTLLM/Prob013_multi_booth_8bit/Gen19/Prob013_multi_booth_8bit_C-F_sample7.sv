module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplicand input
    input      [7:0]  b,      // multiplier input
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam CALC = 1'b1;

    reg state, next_state;

    // Registers for computation - signed 16-bit
    reg signed [15:0] multiplicand;
    reg signed [15:0] product;
    reg [15:0] multiplier;   // Unsigned storing sign-extended multiplier bits

    reg [4:0] ctr;           // 5-bit counter: 0 to 16

    // Control signals
    wire cnt_en;
    wire add_en;

    // Next-state logic for FSM
    always @(*) begin
        case (state)
            IDLE:
                if (!reset)
                    next_state = CALC;
                else
                    next_state = IDLE;
            CALC:
                if (ctr == 5'd16)
                    next_state = IDLE;
                else
                    next_state = CALC;
            default:
                next_state = IDLE;
        endcase
    end

    // Control signals derived combinationally
    assign cnt_en = (state == CALC) && (ctr < 5'd16);
    assign add_en = cnt_en && multiplier[ctr];

    // Sequential logic: registers update
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            ctr <= 5'd0;
            multiplicand <= {{8{a[7]}}, a};  // sign-extend multiplicand input 'a'
            multiplier <= {{8{b[7]}}, b};    // sign-extend multiplier input 'b'
            product <= 16'sd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;
            if (state == IDLE) begin
                ctr <= 5'd0;
                // Reload inputs when entering IDLE state for next operation
                multiplicand <= {{8{a[7]}}, a};
                multiplier <= {{8{b[7]}}, b};
                product <= 16'sd0;
                p <= 16'd0;
                rdy <= 1'b0;
            end else if (state == CALC) begin
                if (cnt_en) begin
                    // Add multiplicand if current multiplier bit is 1
                    if (add_en)
                        product <= product + multiplicand;
                    else
                        product <= product;

                    // Shift multiplicand left by 1
                    multiplicand <= multiplicand <<< 1;

                    // Increment counter
                    ctr <= ctr + 1'b1;
                end

                // When finishing (ctr == 16), latch product and set ready
                if (ctr == 5'd15) begin
                    // Because addition and shift occur before ctr increment,
                    // final addition must be included before output
                    p <= add_en ? (product + multiplicand) : product;
                    rdy <= 1'b1;
                end else begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end
            end
        end
    end

endmodule