module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,        // multiplicand input
    input      [7:0]  b,        // multiplier input
    output reg [15:0] p,        // product output
    output reg        rdy        // ready signal
);

    // FSM states
    typedef enum logic [1:0] {
        IDLE = 2'd0,
        RUN  = 2'd1,
        DONE = 2'd2
    } state_t;

    state_t state, next_state;

    // Registers
    reg signed [15:0] multiplicand;    // sign-extended multiplicand
    reg signed [17:0] product;          // extended to hold intermediate sum and sign
    reg signed [9:0]  multiplier_reg;   // 8 bits of multiplier + 2 extra bits (for Booth recoding)
    reg [3:0]         ctr;              // counts from 0 to 8 (each counts 2 bits processed)

    // Booth recode signal (3 bits): current two multiplier bits + extra bit
    wire [2:0] booth_bits;

    // Partial product (signed)
    reg signed [17:0] partial_product;

    // Compute booth_bits: bits [1:0] plus bit -1 (extra bit)
    // multiplier_reg LSB is bit 0, bit -1 is the bit below it (extra bit)
    // We maintain multiplier_reg shifted right each cycle, initializing with multiplier and 1 zero bit appended
    assign booth_bits = multiplier_reg[1:0] | {1'b0,1'b0}; // placeholder

    always @(*) begin
        // Extract booth bits for current cycle: bits [1:0] and bit -1 (LSB of multiplier_reg is bit 0)
        // For radix-4 Booth, we use bits: [1:0] and [ -1 ] (the bit right before LSB)
        // Here multiplier_reg's bit 0 is LSB, bit 1 next, and bit -1 is bit -1.
        // Since no negative index, the multiplier_reg is extended by 2 bits for this purpose.

        // Since we stored multiplier shifted left by 1 to append zero bit at LSB,
        // booth_bits = {multiplier_reg[1], multiplier_reg[0], multiplier_reg[-1]} = multiplier_reg[2:0]
        // So implement multiplier_reg as 10-bit shifted left by 1 bit (to append 0).

        // We will decode below in next always block.
    end

    // Function for Booth recoding
    function signed [17:0] booth_recode;
        input [2:0] bits;        // 3 bits: [bit1 bit0 bit-1]
        input signed [15:0] m;   // multiplicand (signed extended)
        begin
            case (bits)
                3'b000,
                3'b111: booth_recode = 18'sd0;
                3'b001,
                3'b010: booth_recode = {{2{m[15]}}, m};      // +1 * m, extended to 18 bits
                3'b011: booth_recode = {{1{m[15]}}, m, 1'b0}; // +2 * m (shift left by 1)
                3'b100: booth_recode = -({{1{m[15]}}, m, 1'b0}); // -2 * m
                3'b101,
                3'b110: booth_recode = -({{2{m[15]}}, m});      // -1 * m
                default: booth_recode = 18'sd0;
            endcase
        end
    endfunction

    // Combinational partial product calculation
    wire signed [17:0] partial_product_wire;
    assign partial_product_wire = booth_recode(multiplier_reg[2:0], multiplicand);

    // Next state logic and control signals
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (!reset) next_state = RUN;
            end
            RUN: begin
                if (ctr == 4'd8) next_state = DONE;
            end
            DONE: begin
                if (reset) next_state = IDLE;
            end
            default: next_state = IDLE;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Initialize registers and signals
            state <= IDLE;
            rdy <= 1'b0;
            p <= 16'd0;
            multiplicand <= { {8{b[7]}}, b };
            // Multiplier reg is multiplier shifted left by 1 (append zero bit LSB)
            multiplier_reg <= {1'b0, a, 1'b0}; // 8 bits a + 1 LSB zero appended on each side: total 10 bits
            product <= 18'sd0;
            ctr <= 4'd0;
        end else begin
            state <= next_state;
            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    if (next_state == RUN) begin
                        multiplicand <= { {8{b[7]}}, b };
                        multiplier_reg <= {1'b0, a, 1'b0};
                        product <= 18'sd0;
                        ctr <= 4'd0;
                    end
                end

                RUN: begin
                    // Add partial product to product register
                    // Note: product shifts right logically by 2 bits each cycle, so the partial product is added directly
                    // The multiplier_reg shifted right 2 bits after partial product extraction

                    product <= (product >>> 2) + partial_product_wire;
                    multiplier_reg <= multiplier_reg >>> 2; // shift right by 2 bits
                    ctr <= ctr + 1'b1;
                end

                DONE: begin
                    rdy <= 1'b1;
                    p <= product[15:0];  // take lower 16 bits as final product output
                    // hold registers stable until reset
                end

                default: ;
            endcase
        end
    end

endmodule