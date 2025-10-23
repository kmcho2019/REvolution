module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,       // multiplier input (per problem)
    input      [7:0]  b,       // multiplicand input (per problem)
    output reg [15:0] p,       // product output
    output reg        rdy       // ready signal
);

    // States for FSM
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        RUN  = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    // Internal registers
    reg signed [15:0] multiplicand;    // sign-extended multiplicand
    reg [8:0] multiplier_ext;           // extended multiplier with extra bit for radix-4 booth (one extra LSB bit)
    reg signed [17:0] product;          // extended product register: accumulator + multiplier shifted

    reg [2:0] ctr;                      // count number of radix-4 cycles (0 to 3)

    // Next-state variables
    reg signed [17:0] product_next;
    reg [8:0] multiplier_ext_next;
    reg [2:0] ctr_next;

    // Compute Booth multiple based on 3 bits: [Q2 Q1 Q0]
    // Q0 = bit i*2, Q1 = bit i*2+1, Q2 = bit i*2-1 (overlapping bits)
    // Use radix-4 Booth encoding to generate multiplier factor:
    // 000->0, 001->+1, 010->+1, 011->+2, 100->-2, 101->-1, 110->-1, 111->0

    function signed [17:0] booth_mult;
        input [2:0] bits;
        input signed [15:0] mpcand;
        reg signed [17:0] tmp;
        begin
            case (bits)
                3'b000, 3'b111: tmp = 18'sd0;
                3'b001, 3'b010: tmp = {mpcand, 2'b00};          // +1 * multiplicand << 0
                3'b011:         tmp = {mpcand, 1'b0} << 1;     // +2 * multiplicand << 1 (i.e. multiplicand*2, shift left 1)
                3'b100:         tmp = -({mpcand, 1'b0} << 1);  // -2 * multiplicand << 1
                3'b101, 3'b110: tmp = -{mpcand, 2'b00};         // -1 * multiplicand
                default:        tmp = 18'sd0;
            endcase
            booth_mult = tmp;
        end
    endfunction

    // Extract current 3 bits for Booth encoding at iteration ctr:
    wire [2:0] booth_bits;
    assign booth_bits = multiplier_ext[ctr*2+1 -: 3]; // bits from multiplier_ext starting at (ctr*2+1) down to (ctr*2-1)

    // Control FSM and counter logic
    always @(*) begin
        // Default next state and regs
        next_state = state;
        product_next = product;
        multiplier_ext_next = multiplier_ext;
        ctr_next = ctr;

        case (state)
            IDLE: begin
                if (!reset)
                    next_state = LOAD;
            end

            LOAD: begin
                // Load inputs and initialize regs
                // Go to RUN
                next_state = RUN;
                ctr_next = 3'd0;
            end

            RUN: begin
                if (ctr < 3'd4) begin
                    // Perform one radix-4 booth iteration:
                    // Add or subtract partial product according to booth bits
                    product_next = (product + booth_mult(booth_bits, multiplicand)) >>> 2; // arithmetic shift right 2 bits after addition
                    ctr_next = ctr + 1'b1;
                end else begin
                    next_state = DONE;
                end
            end

            DONE: begin
                // Stay in DONE until reset
                next_state = DONE;
            end

            default: next_state = IDLE;
        endcase
    end

    // State and register updates on clock and reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            product <= 16'd0;
            rdy <= 1'b0;
            multiplicand <= 16'sd0;
            multiplier_ext <= 9'd0;
            product <= 16'd0;
            ctr <= 3'd0;
            product_next <= 18'sd0;
        end else begin
            state <= next_state;
            ctr <= ctr_next;

            if (state == LOAD) begin
                // Sign extend inputs properly:
                multiplicand <= {{8{b[7]}}, b};
                // Multiplier extended with extra 0 LSB bit for Booth
                multiplier_ext <= {a, 1'b0};
                product <= 16'd0;
                product_next <= 18'sd0;
                rdy <= 1'b0;
            end else if (state == RUN) begin
                product_next <= product_next; // to avoid latches
                // update product register
                product <= product_next[15:0]; // lower 16 bits kept for output; internally shifted product_next is 18 bits
                product_next <= product_next;
                // multiplier_ext does not change after load
                rdy <= 1'b0;
            end else if (state == DONE) begin
                rdy <= 1'b1;
                // product output stable
                product <= product_next[15:0];
            end else begin
                rdy <= 1'b0;
            end
        end
    end

endmodule