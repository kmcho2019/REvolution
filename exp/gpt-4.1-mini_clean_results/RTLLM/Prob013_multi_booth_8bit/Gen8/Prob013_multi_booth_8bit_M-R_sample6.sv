module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand
    input      [7:0]   b,      // multiplier
    output reg [15:0]  p,      // product
    output reg         rdy     // ready signal
);

    // Internal registers
    reg signed [15:0] multiplicand;   // sign-extended multiplicand
    reg        [9:0]  extended_multiplier; // multiplier with 2 zero bits appended
    reg signed [31:0] product;         // accumulator with extended width to avoid overflow
    reg [2:0]         cycle_cnt;       // cycle counter 0..4 for 4 radix-4 steps

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

    // Calculate partial product term combinationally
    wire signed [17:0] partial_term = multiplicand * booth_factor; // multiplicand * factor (max ±2)

    // Shifted partial term for alignment
    wire signed [31:0] shifted_term = $signed({{14{partial_term[17]}}, partial_term}) <<< (2 * cycle_cnt);

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
                product   <= product + shifted_term;
                cycle_cnt <= cycle_cnt + 1'b1;
            end else begin
                // Multiplication complete
                p   <= product[15:0];  // final 16-bit product
                rdy <= 1'b1;
            end
        end
    end

endmodule