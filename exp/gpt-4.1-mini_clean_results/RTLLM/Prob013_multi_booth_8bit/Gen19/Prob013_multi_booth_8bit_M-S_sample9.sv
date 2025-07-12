module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,      // multiplicand (signed)
    input  [7:0]    b,      // multiplier   (signed)
    output reg [15:0] p,    // product
    output reg       rdy     // ready signal
);

    // Internal registers
    reg signed [8:0] multiplicand;    // sign-extended multiplicand (9 bits)
    reg signed [8:0] multiplier_reg;  // multiplier extended with extra bit for Booth (9 bits)
    reg signed [17:0] accumulator;    // accumulator for partial sums (18 bits)
    reg [2:0] step;                   // counts steps 0..4 (each processes 2 bits)

    wire [2:0] booth_bits;
    reg signed [17:0] partial_product;

    // Extract 3 LSBs for Booth encoding
    assign booth_bits = multiplier_reg[2:0];

    // Combinational partial product calculation based on Booth encoding
    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = 18'sd0;
            3'b001, 3'b010: partial_product = {{9{multiplicand[8]}}, multiplicand};            // +1 * multiplicand
            3'b011:         partial_product = {{8{multiplicand[8]}}, multiplicand, 1'b0};      // +2 * multiplicand
            3'b100:         partial_product = -({{8{multiplicand[8]}}, multiplicand, 1'b0});   // -2 * multiplicand
            3'b101, 3'b110: partial_product = -({{9{multiplicand[8]}}, multiplicand});        // -1 * multiplicand
            default:        partial_product = 18'sd0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            multiplicand  <= {a[7], a};           // sign extend multiplicand
            multiplier_reg<= {b, 1'b0};           // extend multiplier with extra 0 bit (for Booth)
            accumulator   <= 18'sd0;
            step          <= 3'd0;
            p             <= 16'd0;
            rdy           <= 1'b0;
        end else if (step < 3'd4) begin
            accumulator   <= accumulator + partial_product;
            // Arithmetic shift right multiplier_reg by 2 bits
            multiplier_reg <= { {2{multiplier_reg[8]}}, multiplier_reg[8:2] };
            step          <= step + 1'b1;
            rdy           <= 1'b0;
        end else if (step == 3'd4) begin
            // Done: output product and set ready
            p   <= accumulator[15:0];
            rdy <= 1'b1;
        end
    end

endmodule