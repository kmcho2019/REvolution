module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand
    input      [7:0]   b,      // multiplier
    output reg [15:0]  p,      // product
    output reg         rdy     // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand;         // sign-extended multiplicand
    reg        [9:0]  extended_multiplier;  // multiplier with 2 zero bits appended
    reg signed [31:0] product;               // accumulator with extended width to avoid overflow
    reg [2:0]         cycle_cnt;             // cycle counter 0..4 for 4 radix-4 steps

    // Booth code bits for current cycle (3 bits)
    wire [2:0] booth_bits;
    assign booth_bits = extended_multiplier[2 + 2*cycle_cnt -: 3];

    // Decode Booth bits combinationally to factor: -2, -1, 0, 1, 2
    reg signed [2:0] booth_factor;
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: booth_factor =  3'sd0;
            3'b001, 3'b010: booth_factor =  3'sd1;
            3'b011:         booth_factor =  3'sd2;
            3'b100:         booth_factor = -3'sd2;
            3'b101, 3'b110: booth_factor = -3'sd1;
            default:        booth_factor =  3'sd0;
        endcase
    end

    // Compute partial product using shift and add/subtract instead of multiplication
    reg signed [16:0] partial_term; // 17 bits: one extra for shifted multiplicand
    always @(*) begin
        case (booth_factor)
            3'sd0: partial_term = 17'sd0;
            3'sd1: partial_term = {multiplicand[15], multiplicand};         // just multiplicand (16 bits) sign-extended 17 bits
            3'sd2: partial_term = {multiplicand[15], multiplicand} << 1;    // multiplicand * 2 by shift left 1
           -3'sd1: partial_term = -{multiplicand[15], multiplicand};
           -3'sd2: partial_term = -({multiplicand[15], multiplicand} << 1);
            default: partial_term = 17'sd0;
        endcase
    end

    // Shift partial_term appropriately for current cycle (2 bits per cycle)
    wire signed [31:0] shifted_term = $signed({{15{partial_term[16]}}, partial_term}) <<< (2 * cycle_cnt);

    // Main sequential logic with asynchronous reset
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand       <= {{8{a[7]}}, a};    // sign-extend multiplicand to 16 bits
            extended_multiplier <= {b, 2'b00};       // 8-bit multiplier with two appended zeros for radix-4 Booth
            product            <= 32'sd0;
            cycle_cnt          <= 3'd0;
            p                  <= 16'd0;
            rdy                <= 1'b0;
        end else if (!rdy) begin
            if (cycle_cnt < 3'd4) begin
                // Only update product if partial_term != 0 to reduce unnecessary switching
                if (partial_term != 17'sd0)
                    product <= product + shifted_term;
                cycle_cnt <= cycle_cnt + 1'b1;
            end else begin
                // Multiplication complete
                p   <= product[15:0];  // final 16-bit product
                rdy <= 1'b1;
            end
        end
    end

endmodule