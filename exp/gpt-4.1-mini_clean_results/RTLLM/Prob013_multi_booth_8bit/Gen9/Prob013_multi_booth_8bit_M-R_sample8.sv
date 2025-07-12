module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplier input
    input      [7:0]  b,      // multiplicand input
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    // State encoding
    typedef enum logic [1:0] {
        IDLE  = 2'b00,
        RUN   = 2'b01,
        DONE  = 2'b10
    } state_t;

    state_t state, next_state;

    // Registers for multiplier, multiplicand, product, and counter
    reg signed [15:0] multiplier;
    reg signed [15:0] multiplicand;
    reg signed [15:0] product;
    reg [4:0] ctr;

    // Combinational next value for product
    reg signed [15:0] product_next;
    reg signed [15:0] multiplicand_next;

    // Control signals
    wire multiplier_bit;

    assign multiplier_bit = multiplier[ctr];

    // State register and counter update process
    always @(posedge clk) begin
        if (reset) begin
            // Initialize all registers at reset
            multiplier   <= {{8{a[7]}}, a}; // sign-extend a
            multiplicand <= {{8{b[7]}}, b}; // sign-extend b
            product      <= 16'sd0;
            ctr          <= 5'd0;
            state        <= IDLE;
            p            <= 16'd0;
            rdy          <= 1'b0;
        end else begin
            state <= next_state;
            if (state == RUN) begin
                product      <= product_next;
                multiplicand <= multiplicand_next;
                ctr          <= ctr + 1;
            end else if (state == IDLE) begin
                // Reset counter and product at start of multiplication
                ctr     <= 5'd0;
                product <= 16'sd0;
                // multiplier, multiplicand remain constant during RUN
            end else if (state == DONE) begin
                p   <= product;
                rdy <= 1'b1;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = RUN;
            RUN:  next_state = (ctr == 5'd16) ? DONE : RUN;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath logic for product accumulation and multiplicand shift
    always @(*) begin
        if (state == RUN) begin
            // If current multiplier bit is 1, add multiplicand to product; else product unchanged
            product_next = multiplier_bit ? (product + multiplicand) : product;
            // Shift multiplicand left by 1 for next cycle
            multiplicand_next = multiplicand <<< 1;
        end else begin
            product_next = product;
            multiplicand_next = multiplicand;
        end
    end

endmodule