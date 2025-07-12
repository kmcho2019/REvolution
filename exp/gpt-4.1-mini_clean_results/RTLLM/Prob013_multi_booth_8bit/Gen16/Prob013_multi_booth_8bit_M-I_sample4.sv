module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,    // multiplicand
    input      [7:0]  b,    // multiplier
    output reg [15:0] p,    // product
    output reg        rdy    // ready flag
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
    reg signed [15:0] multiplicand;   // sign-extended multiplicand (constant during multiply)
    reg signed [17:0] product;        // extended product register: 16 bits + 2 bits extra for radix-4 encoding (total 18 bits)
    reg [3:0]         cycle_count;    // 4 bits to count 8 cycles (0 to 7)

    // Radix-4 Booth recoding uses 3 bits from product[1: -1], so we need a bit below LSB; we add a zero bit at the start.
    // product[0] and product[-1] are handled by extending product with 2 bits.

    // Next state logic
    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (!reset)
                    next_state = LOAD;
            end
            LOAD: begin
                next_state = RUN;
            end
            RUN: begin
                if (cycle_count == 4'd8)
                    next_state = DONE;
            end
            DONE: begin
                // Stay in DONE until reset
                if (reset)
                    next_state = IDLE;
            end
        endcase
    end

    // Booth recoding helper function: input 3 bits, output multiply factor (-2, -1, 0, 1, 2)
    // Encoding according to Radix-4 Booth algorithm:
    // bits | action
    // 000  | 0
    // 001  | +1
    // 010  | +1
    // 011  | +2
    // 100  | -2
    // 101  | -1
    // 110  | -1
    // 111  | 0
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case (bits)
                3'b000: booth_decode = 3'sd0;
                3'b001: booth_decode = 3'sd1;
                3'b010: booth_decode = 3'sd1;
                3'b011: booth_decode = 3'sd2;
                3'b100: booth_decode = -3'sd2;
                3'b101: booth_decode = -3'sd1;
                3'b110: booth_decode = -3'sd1;
                3'b111: booth_decode = 3'sd0;
                default: booth_decode = 3'sd0;
            endcase
        end
    endfunction

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= 16'sd0;
            product <= 18'd0;
            cycle_count <= 4'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;
            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    p <= 16'd0;
                    cycle_count <= 4'd0;
                    product <= 18'd0;
                    multiplicand <= 16'sd0;
                end
                LOAD: begin
                    // Load inputs with sign-extension
                    multiplicand <= { {8{a[7]}}, a }; // multiplicand
                    // Initialize product register: concatenation of multiplier with 2 zero bits appended right:
                    // product = { multiplier(8 bits), 9 zero bits }
                    // For Radix-4 Booth, extend multiplier by 1 bit at LSB = 0 for recoding (one extra zero)
                    // We put multiplier in product[17:9], lower bits product[8:0] = 0 initially, but for Booth we append 1 zero bit at LSB
                    // To simplify, we load multiplier in lower bits + an appended zero at LSB (product[0]) 
                    product <= { {9{b[7]}}, b, 1'b0 };  // 8 bits b sign-extended to 9 bits + 1 zero at LSB = 18 bits total
                    cycle_count <= 4'd0;
                end
                RUN: begin
                    // Extract 3 bits for Booth recoding: product[1: -1]
                    // product is 18 bits: bits [17:0]
                    // Since Verilog does not support negative indices, we consider product[1:0] and the appended zero at LSB.
                    // The three bits are product[1], product[0], and product[-1] (virtual zero)
                    // As we appended zero at LSB product[0], product[-1] = 0
                    // So for each cycle, the 3 bits are product[1:0] plus an appended zero at LSB (effectively product[1:0] & 0)
                    // But since we only appended one zero bit at LSB, the 3 bits per cycle are product[1: -1]:
                    // product[1], product[0], and an imaginary bit 0
                    // For shift, we will shift product right by 2 bits after addition/subtraction
                    //
                    // To simplify, shift right logical by 2 bits each cycle, recode bits are product[1: -1] (in code, product[1:0] + 0 bit)
                    //
                    // To do this correctly, at each cycle, take product[1:0] plus next bit product[2] to form 3 bits for recoding:
                    // Correct method: take product[2:0] bits as the recode bits (3 bits)
                    // Shift right by 2 after operation.

                    // Extract recode bits
                    // product[2:0]
                    reg [2:0] recode_bits;
                    recode_bits = product[2:0];

                    // Decode recode bits
                    reg signed [2:0] mult_factor;
                    mult_factor = booth_decode(recode_bits);

                    // Calculate partial product = multiplicand * mult_factor
                    reg signed [17:0] partial_product;
                    partial_product = mult_factor * multiplicand; // multiplicand is 16-bit signed, extend to 18-bit signed for addition

                    // Align partial product by shifting left to position it correctly in product reg:
                    // Since product[17:0] shifts right by 2 bits each cycle, partial_product is added directly.

                    // Add partial product to product shifted right (product after arithmetic add/subtract)
                    // Because product shifted right after addition, partial product added at current position.

                    // Perform addition
                    product <= (product >>> 2) + partial_product;

                    cycle_count <= cycle_count + 1'b1;
                end
                DONE: begin
                    // Output final product and set ready
                    p <= product[17:2]; // bits [17:2] contain final 16-bit product after all shifts
                    rdy <= 1'b1;
                end
            endcase
        end
    end

endmodule