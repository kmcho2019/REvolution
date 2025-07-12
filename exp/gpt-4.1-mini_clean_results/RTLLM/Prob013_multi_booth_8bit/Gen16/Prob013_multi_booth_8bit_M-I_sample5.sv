module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,       // multiplier input
    input      [7:0]  b,       // multiplicand input
    output reg [15:0] p,       // product output
    output reg        rdy       // ready signal
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        RUN  = 2'b10,
        DONE = 2'b11
    } state_t;

    state_t state, next_state;

    // Extended registers with sign extension
    reg signed [15:0] multiplicand; // sign-extended multiplicand
    reg signed [8:0]  multiplier_ext; // multiplier extended with one bit for Booth encoding

    reg [1:0] ctr; // counts cycles, 0..3 (4 cycles for 8 bits / 2 bits per cycle)

    reg signed [33:0] acc, acc_next; // accumulator wide enough to hold shifted partial sums

    // Signals for Booth encoding and partial product
    reg [2:0] booth_bits;
    reg signed [15:0] pp; // partial product

    // Sequential logic for FSM and registers
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= 16'sd0;
            multiplier_ext <= 9'd0;
            acc <= 34'd0;
            ctr <= 2'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;

            if (state == LOAD) begin
                // sign-extend inputs
                multiplicand <= {{8{b[7]}}, b};      // multiplicand from b (16-bit signed)
                multiplier_ext <= {a[0], a, 1'b0};   // multiplier extended with LSB=0 for encoding
                acc <= 34'd0;
                ctr <= 2'd0;
                rdy <= 1'b0;
                p <= 16'd0;
            end else if (state == RUN) begin
                acc <= acc_next;
                multiplier_ext <= multiplier_ext >> 2;
                ctr <= ctr + 1'b1;
            end else if (state == DONE) begin
                p <= acc[15:0]; // lower 16 bits of accumulator is the product
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;
            end
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE:  next_state = reset ? IDLE : LOAD;
            LOAD:  next_state = RUN;
            RUN:   next_state = (ctr == 2'd3) ? DONE : RUN;
            DONE:  next_state = DONE; // wait for reset
            default: next_state = IDLE;
        endcase
    end

    // Booth partial product generation
    always @(*) begin
        // Extract 3 bits for Booth encoding: multiplier_ext[2:0]
        booth_bits = multiplier_ext[2:0];

        // Decode booth_bits into partial product:
        // Encoding table (radix-4):
        // 000,111 =>  0
        // 001,010 => +1 * multiplicand
        // 011      => +2 * multiplicand
        // 100      => -2 * multiplicand
        // 101,110 => -1 * multiplicand

        case (booth_bits)
            3'b000, 3'b111: pp = 16'sd0;
            3'b001, 3'b010: pp = multiplicand;
            3'b011:         pp = multiplicand <<< 1;    // *2
            3'b100:         pp = -(multiplicand <<< 1); // *-2
            3'b101, 3'b110: pp = -multiplicand;
            default:        pp = 16'sd0;
        endcase
    end

    // Next accumulator value computation with shifting of partial product according to cycle (ctr)
    always @(*) begin
        // Shift partial product by 2*ctr bits to align with multiplier bits processed
        acc_next = acc + ({{18{pp[15]}}, pp} <<< (2*ctr));
        // Extend partial product to 34 bits by sign extension:
        // pp is 16 bits signed => extend to 34 bits by replicating sign bit
    end

endmodule