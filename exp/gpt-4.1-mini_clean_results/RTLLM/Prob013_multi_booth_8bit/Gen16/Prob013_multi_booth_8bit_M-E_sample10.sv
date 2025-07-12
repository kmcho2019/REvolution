module multi_booth_8bit (
    input             clk,
    input             reset,
    input      [7:0]  a,      // multiplier
    input      [7:0]  b,      // multiplicand
    output reg [15:0] p,      // product output
    output reg        rdy      // ready signal
);

    // FSM states
    typedef enum reg [1:0] {
        IDLE = 2'd0,
        LOAD = 2'd1,
        MULT = 2'd2,
        DONE = 2'd3
    } state_t;

    state_t state, next_state;

    // Registers:
    // multiplicand: 16-bit signed with sign-extended b
    reg signed [15:0] multiplicand;

    // product: 17 bits wide to hold intermediate sums, signed
    reg signed [16:0] product;

    // multiplier_shifted: 9 bits (8 bits multiplier plus 1 extra zero bit LSB)
    reg [8:0] multiplier_shifted;

    // cycle counter: 2 bits (0 to 3) for 4 iterations (since radix-4 processes 2 bits per cycle)
    reg [1:0] cycle_ctr;

    // Internal signals
    reg signed [16:0] pp; // partial product (multiplicand multiplied by Booth digit and shifted)

    // Extract the current 3 bits for Booth recoding:
    wire [2:0] booth_bits = multiplier_shifted[2:0];

    // Booth encoding logic for radix-4 (3 bits group)
    // Returns the multiplier for multiplicand: -2, -1, 0, 1, or 2
    function signed [2:0] booth_decode;
        input [2:0] bits;
        begin
            case(bits)
                3'b000, 3'b111: booth_decode = 3'sd0;
                3'b001, 3'b010: booth_decode = 3'sd1;
                3'b011:         booth_decode = 3'sd2;
                3'b100:         booth_decode = -3'sd2; // -2
                3'b101, 3'b110: booth_decode = -3'sd1; // -1
                default:        booth_decode = 3'sd0;
            endcase
        end
    endfunction

    reg signed [2:0] booth_mul; // output of booth decoder

    // Next state logic combinational
    always @(*) begin
        next_state = state;
        case(state)
            IDLE: begin
                if (!reset) // wait for reset deasserted
                    next_state = LOAD;
            end
            LOAD: next_state = MULT;
            MULT: begin
                if (cycle_ctr == 2'd3)
                    next_state = DONE;
            end
            DONE: begin
                if (reset)
                    next_state = IDLE;
            end
        endcase
    end

    // Partial product calculation combinational
    always @(*) begin
        booth_mul = booth_decode(booth_bits);

        // Partial product is multiplicand * booth_mul shifted left by 2*cycle_ctr (accumulated in product register)
        // But we add/subtract multiplicand multiples aligned to product register's LSB.
        // Since we shift multiplier right by 2 bits each cycle, product holds accumulated sum, and multiplicand is constant.
        // So here we just generate multiplicand * booth_mul shifted by 0 (the shifting effect is implicit in the product register shifting).

        // For radix-4 booth multiplication, we add multiplicand * booth_mul (shifted according to position)
        // We implement shifting by shifting partial product left by 2*cycle_ctr bits later when accumulating product.

        // However, since product holds accumulated result shifted already, we directly add (multiplicand*booth_mul)<< (2*cycle_ctr)
        // But the product register will be shifted right after addition accordingly.

        // To simplify, we keep product in the same scale, we shift multiplicand * booth_mul by 2*cycle_ctr bits.

        // Because the multiplier is shifted right by 2 bits after each iteration, partial products correspond to different weight positions.

        // So compute partial product shifted by 2*cycle_ctr:
        pp = ($signed({{8{multiplicand[15]}}, multiplicand}) * booth_mul) <<< (2*cycle_ctr);
    end

    // Sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            multiplicand <= 16'sd0;
            multiplier_shifted <= 9'd0;
            product <= 17'sd0;
            cycle_ctr <= 2'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            state <= next_state;

            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                end
                LOAD: begin
                    // Load sign-extended inputs
                    multiplicand <= {{8{b[7]}}, b};    // 16-bit signed multiplicand
                    // multiplier_shifted = multiplier (a) with extra zero bit appended at LSB
                    multiplier_shifted <= {a, 1'b0};
                    product <= 17'sd0;
                    cycle_ctr <= 2'd0;
                    rdy <= 1'b0;
                end
                MULT: begin
                    // Add the partial product calculated combinationally
                    product <= product + pp;

                    // Shift multiplier right by 2 bits for next iteration
                    multiplier_shifted <= multiplier_shifted >> 2;

                    // increment cycle counter
                    cycle_ctr <= cycle_ctr + 1'b1;

                    rdy <= 1'b0;
                end
                DONE: begin
                    // Output the final 16-bit product (take bits [15:0] of product)
                    p <= product[15:0];
                    rdy <= 1'b1;
                end
                default: ;
            endcase
        end
    end

endmodule