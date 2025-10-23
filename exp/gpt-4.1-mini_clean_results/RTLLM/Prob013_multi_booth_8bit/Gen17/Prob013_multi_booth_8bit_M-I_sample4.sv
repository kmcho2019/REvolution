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

    // Registers
    reg signed [15:0] multiplicand;    // sign-extended multiplicand
    reg signed [17:0] product;         // accumulator extended by 2 bits for shifting
    reg [17:0] multiplier_ext;         // multiplier extended with appended zero for Booth recoding
    reg [2:0] booth_bits;              // current 3-bit Booth code
    reg [3:0] ctr;                    // iteration counter (8 cycles)

    // partial product based on Booth encoding
    reg signed [17:0] partial_prod;

    // Combinational Booth recoding lookup function (3 bits -> multiple of multiplicand)
    // Encoding: [y_{i+1}, y_i, y_{i-1}] = booth_bits
    // Return: partial product to add (multiplicand * {0,±1,±2})
    // Radix-4 Booth recoding rules:
    // 000 -> 0
    // 001 -> +1*M
    // 010 -> +1*M
    // 011 -> +2*M
    // 100 -> -2*M
    // 101 -> -1*M
    // 110 -> -1*M
    // 111 -> 0

    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_prod = 18'sd0;
            3'b001, 3'b010: partial_prod = {multiplicand, 2'b00}; partial_prod = multiplicand <<< 0; // +1*M shifted 0 bits
            3'b011:         partial_prod = (multiplicand <<< 1);  // +2*M
            3'b100:         partial_prod = -(multiplicand <<< 1); // -2*M
            3'b101, 3'b110: partial_prod = -({multiplicand, 2'b00}); partial_prod = -multiplicand; // -1*M
            default:        partial_prod = 18'sd0;
        endcase
    end

    // FSM sequential
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            rdy <= 1'b0;
            p <= 16'd0;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                end

                LOAD: begin
                    // Load inputs with sign extension
                    // multiplicand sign-extended 8->16
                    // multiplier sign-extended and append 1 zero bit LSB for Booth recoding
                    multiplicand <= {{8{b[7]}}, b};
                    multiplier_ext <= { {a[7]}, a, 1'b0 }; // 8+1=9 bits extended with sign for simplicity
                    product <= 18'sd0; // accumulator zero
                    ctr <= 4'd0;
                end

                RUN: begin
                    // Nothing synchronous here; partial_prod and booth_bits combinational
                    // Update product and multiplier_ext below
                end

                DONE: begin
                    rdy <= 1'b1;
                    // Hold outputs stable
                end
            endcase
        end
    end

    // FSM next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = reset ? IDLE : LOAD;
            LOAD: next_state = RUN;
            RUN:   next_state = (ctr == 4'd8) ? DONE : RUN;
            DONE:  next_state = IDLE; // Wait for reset to start next multiply
            default: next_state = IDLE;
        endcase
    end

    // Compute booth_bits and update on RUN state
    always @(posedge clk) begin
        if (!reset) begin
            if (state == LOAD) begin
                ctr <= 4'd0;
                product <= 18'sd0;
                rdy <= 1'b0;
            end else if (state == RUN) begin
                // Extract current 3 bits for Booth recoding from multiplier_ext
                // Starting from bit position 2*ctr to 2*ctr+2
                booth_bits <= multiplier_ext[2*ctr +: 3];

                // Compute partial product based on booth_bits (combinational assigned above)

                // Accumulate partial product shifted appropriately:
                // Since partial_prod already aligned (multiplicand shifted by 0 or 1 bits),
                // Shift partial_prod left by 2*ctr bits to align contribution
                product <= product + (partial_prod <<< (2*ctr));

                ctr <= ctr + 1'b1;

                if (ctr == 4'd7) begin
                    // On last iteration (ctr=7 before increment), finalize output next cycle
                    p <= product[17:2];  // Drop last 2 bits as product is shifted left with 2 bits extra
                    rdy <= 1'b1;
                end
            end else if (state == DONE) begin
                // Hold product and ready stable
                p <= product[17:2];
                rdy <= 1'b1;
            end else if (state == IDLE) begin
                rdy <= 1'b0;
                p <= 16'd0;
            end
        end else begin
            // On reset, clear
            product <= 18'sd0;
            multiplicand <= 16'sd0;
            multiplier_ext <= 18'd0;
            ctr <= 4'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end
    end

endmodule