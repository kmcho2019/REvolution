module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);
    // State machine states
    typedef enum logic [1:0] {
        IDLE = 2'b00,
        CALC = 2'b01,
        DONE = 2'b10
    } state_t;

    state_t state, next_state;

    reg signed [16:0] multiplicand; // 17 bits signed (extended from 8-bit)
    reg signed [32:0] product;      // 33 bits: upper 17 bits partial sum, lower 16 bits multiplier bits + Q-1 bit (1 bit)
    reg [2:0] ctr;                  // Counts 0..4 (4 cycles for radix-4)

    // Extract bits used for Booth decoding:
    // For Radix-4 Booth: use product[1:0] and product[0] = Q-1 bit
    // Actually the three bits: product[1:0] and product[0] (Q-1), but Q-1 is product[0] itself.
    // For radix-4 Booth decoding, the bits are product[1:0] plus product[2] (which is next bit for next cycle), but here
    // the standard is to use bits product[1:0] and Q-1 bit = product[0]
    wire [2:0] booth_bits = {product[1], product[0], product[0]}; 
    // Actually, the standard radix-4 booth encoding examines bits (Q_i+1, Q_i, Q_i-1)
    // We have product [1:0] and Q-1 is product[0], but repeated as per standard? Let's define the 3 bits as:
    // Booth bits: {product[2], product[1], product[0]} for each iteration.
    // We'll correct below:

    // Correct booth bits for radix-4: bits product[1:0] + Q-1 bit = product[0]
    // Since product has multiplier bits in lower 16 bits + Q-1 appended in LSB product[0]
    // On first cycle Q-1 = 0 (initialized)

    wire [2:0] booth_code = {product[2], product[1], product[0]};

    // Booth operation: returns the signed value to add/subtract to upper 17 bits of product
    // Based on radix-4 booth encoding:
    // 000 or 111: 0
    // 001 or 010: +1 * multiplicand
    // 011: +2 * multiplicand
    // 100: -2 * multiplicand
    // 101 or 110: -1 * multiplicand

    function signed [16:0] booth_calc;
        input [2:0] bits;
        begin
            case(bits)
                3'b000,
                3'b111: booth_calc = 17'sd0;
                3'b001,
                3'b010: booth_calc = multiplicand;
                3'b011: booth_calc = multiplicand <<< 1;  // *2
                3'b100: booth_calc = -(multiplicand <<< 1); // -2 * multiplicand
                3'b101,
                3'b110: booth_calc = -multiplicand;
                default: booth_calc = 17'sd0;
            endcase
        end
    endfunction

    // Next state logic
    always @(*) begin
        case(state)
            IDLE: next_state = reset ? IDLE : CALC;
            CALC: next_state = (ctr == 3'd4) ? DONE : CALC;
            DONE: next_state = reset ? IDLE : DONE;
            default: next_state = IDLE;
        endcase
    end

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset: sign-extend inputs, initialize product and registers
            multiplicand <= {{9{a[7]}}, a};  // 8-bit sign extended to 17-bit
            // product lower 17 bits: multiplier + Q-1 = 0 appended as LSB product[0]
            // multiplier sign-extended 8-bit to 16-bit, then append Q-1
            product <= {16'd0, b, 1'b0};  // upper 17 bits zero, lower 16 bits multiplier plus Q-1 bit = 0
            ctr <= 3'd0;
            rdy <= 1'b0;
            p <= 16'd0;
            state <= IDLE;
        end else begin
            state <= next_state;

            case (state)
                IDLE: begin
                    rdy <= 1'b0;
                    ctr <= 3'd0;
                    p <= 16'd0;
                    multiplicand <= multiplicand; // hold
                    product <= product;           // hold
                end
                CALC: begin
                    // Perform Booth operation on upper half of product (bits 32:16)
                    // Add booth_calc output to product[32:16]
                    // product[32:16] is 17 bits signed partial sum

                    // Calculate addition
                    // Extract upper 17 bits signed:
                    reg signed [16:0] upper;
                    upper = product[32:16];

                    // Booth calc value
                    reg signed [16:0] val;
                    val = booth_calc(booth_code);

                    // Add val
                    upper = upper + val;

                    // Compose new product:
                    // Shift right arithmetic product by 2 bits to prepare for next cycle

                    // Compose new product before shift:
                    reg signed [32:0] prod_pre_shift;
                    prod_pre_shift = {upper, product[15:0]};

                    // Arithmetic right shift by 2 bits:
                    // Since product is signed 33 bits, replicating sign bit:
                    // Use arithmetic shift operator '>>>'
                    product <= prod_pre_shift >>> 2;

                    ctr <= ctr + 1;
                end
                DONE: begin
                    // Output product
                    p <= product[16:1]; 
                    // Explanation:
                    // product[16:1] is 16 bits product result after shifts.
                    // product[0] is Q-1 bit which should be discarded.
                    rdy <= 1'b1;
                end
            endcase
        end
    end
endmodule