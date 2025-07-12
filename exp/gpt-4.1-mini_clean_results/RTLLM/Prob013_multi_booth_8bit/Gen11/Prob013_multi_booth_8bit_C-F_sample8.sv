module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,     // multiplicand
    input      [7:0]   b,     // multiplier
    output reg [15:0]  p,     // product output
    output reg         rdy     // ready signal
);

    // FSM states
    localparam IDLE = 1'b0;
    localparam BUSY = 1'b1;
    reg state;

    // Radix-4 Booth multiplier variables
    // We'll use a 33-bit register combining partial product (upper 17 bits)
    // and multiplier extended by 1 bit (lower 16 bits), signed arithmetic.
    // Width explanation:
    // partial product: 17 bits to accommodate overflow (16 + 1 sign bit)
    // multiplier: 16 bits (8 bits * 2 bits per iteration) with extra bit appended for Booth encoding
    reg signed [32:0] pp_mult;    // partial product and multiplier combined

    // Sign-extended multiplicand shifted as needed
    reg signed [16:0] multiplicand_ext;  // 17 bits to support multiplication by ±2 (1 extra bit)

    reg [3:0] ctr;  // 4-bit counter for 8 cycles (2 bits processed per cycle)

    // Temporary variable for Booth encoding
    reg [2:0] booth_bits;

    // Function to compute booth multiple based on booth_bits
    // Returns a signed 18-bit value (to accommodate ±2 * multiplicand_ext)
    function signed [17:0] booth_decode;
        input [2:0] bits;
        reg signed [17:0] val;
        begin
            case (bits)
                3'b000,
                3'b111: val = 18'sd0;                  //  0
                3'b001,
                3'b010: val = multiplicand_ext;       // +1 * multiplicand
                3'b011: val = multiplicand_ext <<< 1; // +2 * multiplicand
                3'b100: val = -(multiplicand_ext <<< 1); // -2 * multiplicand
                3'b101,
                3'b110: val = -multiplicand_ext;      // -1 * multiplicand
                default: val = 18'sd0;
            endcase
            booth_decode = val;
        end
    endfunction

    always @(posedge clk) begin
        if (reset) begin
            // On reset:
            // - Sign-extend multiplicand to 17 bits (add 1 zero LSB for shifts)
            // - Prepare multiplier extended with extra LSB 0 (for Booth encoding)
            //   multiplier is placed in bits [15:0], with an appended 0 at bit 0
            multiplicand_ext <= { {9{a[7]}}, a }; // 8 + 9 = 17 bits
            // Build pp_mult as:
            // partial product = 0 (upper 17 bits)
            // multiplier_ext = {b[7], b, 1'b0} => 16 + 1 bits = 17 bits stored in lower bits
            // We place partial product in upper bits and multiplier + extra bit in lower bits:
            // Thus pp_mult[32:16] = partial product (17 bits), initialized to zero
            // pp_mult[15:0]  = multiplier with appended 0 bit at LSB => Actually 16 bits input + extra bit, so 17 bits total.
            // To align to 33 bits total, we'll store multiplier extended bits [16:0] in pp_mult[16:0]
            pp_mult <= {17'd0, {b, 1'b0}}; // total 33 bits: [32:16] partial product, [15:0] multiplier + 1 bit appended
            ctr <= 4'd0;
            p <= 16'd0;
            rdy <= 1'b0;
            state <= IDLE;
        end else begin
            case(state)
                IDLE: begin
                    rdy <= 1'b0;
                    ctr <= 4'd0;
                    p <= 16'd0;
                    state <= BUSY;
                end

                BUSY: begin
                    if (ctr < 4'd8) begin
                        // Extract the lowest 3 bits from pp_mult to decode the Booth operation
                        // The 3 bits are pp_mult[2:0]
                        booth_bits = pp_mult[2:0];
                        // Calculate booth multiple
                        // Add/subtract to partial product part (pp_mult[32:16])
                        pp_mult[32:16] <= pp_mult[32:16] + booth_decode(booth_bits);
                        // Arithmetic right shift pp_mult by 2 bits for next cycle
                        // Using arithmetic shift to keep sign extension on partial product part
                        // Combine partial product + multiplier (33 bits), so arithmetic right shift by 2:
                        // For signed arithmetic shift by 2:
                        pp_mult <= {pp_mult[32], pp_mult[32:2]}; // first shift right by 1 (with sign), then shift again by 1 bit (logical)
                        // But need arithmetic shift by 2 bits with sign extension:
                        // To do this in one step:
                        pp_mult <= $signed(pp_mult) >>> 2;
                        ctr <= ctr + 1;
                    end else begin
                        // Multiplication finished
                        // The result is in pp_mult[32:17], total 16 bits output p[15:0]
                        // The bits [32:17] represent the 16-bit product
                        p <= pp_mult[32:17];
                        rdy <= 1'b1;
                        state <= IDLE; // ready for next operation after reset
                    end
                end

                default: state <= IDLE;
            endcase
        end
    end

endmodule