module multi_booth_8bit (
    input           clk,
    input           reset,
    input  [7:0]    a,    // multiplicand
    input  [7:0]    b,    // multiplier
    output reg [15:0] p,   // product
    output reg       rdy
);

    // Extended registers for signed operations
    reg signed [16:0] product_acc;       // partial product (17 bits to accommodate shifts)
    reg signed [8:0]  multiplicand_ext; // multiplicand extended to 9 bits for arithmetic
    reg [7:0]         multiplier_reg;   // multiplier register
    reg [2:0]         step_count;       // 3-bit counter for 4 steps (0..3)

    wire [2:0] booth_bits; // 3 bits used for Radix-4 Booth encoding

    // Extract Booth bits: q_{i+1}, q_i, q_{i-1}
    // For i-th step, the bits are multiplier_reg[2*step_count +1 : 2*step_count -1]
    // We implement this by shifting multiplier_reg left by 1, then taking bits [2*step_count+1:2*step_count -1]
    // To handle i-1 = -1 at first step, we implicitly add a 0 at LSB via {multiplier_reg,1'b0}
    wire [8:0] mul_ext = {multiplier_reg, 1'b0}; // 9 bits with zero padded LSB

    assign booth_bits = mul_ext[2*step_count +: 3]; // select 3 bits for current step

    // Booth decoding function: returns multiplicand multiplier based on booth_bits
    // 3-bit pattern to multiply multiplicand by -2, -1, 0, 1, or 2
    // Mapping (booth_bits): operation
    // 000 / 111 =  0
    // 001 / 010 = +1 * M
    // 011        = +2 * M
    // 100        = -2 * M
    // 101 / 110 = -1 * M
    reg signed [9:0] muxed_m; // 10-bit to hold +/-2*M

    always @(*) begin
        case (booth_bits)
            3'b000,
            3'b111: muxed_m = 10'sd0;
            3'b001,
            3'b010: muxed_m = {multiplicand_ext[8], multiplicand_ext};          // +1*M (sign-extended)
            3'b011: muxed_m = {multiplicand_ext[8], multiplicand_ext} <<< 1;    // +2*M
            3'b100: muxed_m = -({multiplicand_ext[8], multiplicand_ext} <<< 1); // -2*M
            3'b101,
            3'b110: muxed_m = -{multiplicand_ext[8], multiplicand_ext};         // -1*M
            default: muxed_m = 10'sd0;
        endcase
    end

    always @(posedge clk) begin
        if (reset) begin
            // Initialize on reset:
            // multiplicand extended sign-extended to 9 bits for overflow margin
            multiplicand_ext <= {a[7], a};
            multiplier_reg <= b;
            // product_acc initialized with multiplier shifted left 1 bit (to allow signed shifts)
            // Start product as 0, then add multiplicand multiples in steps
            product_acc <= {{8{1'b0}}, 1'b0}; // zero init
            step_count <= 0;
            rdy <= 0;
            p <= 0;
        end else if (!rdy) begin
            // Iterative steps (4 times)
            if (step_count < 4) begin
                // Add or subtract multiplicand multiple
                product_acc <= (product_acc + muxed_m) >>> 2; 
                // Arithmetic shift right by 2 bits for next step
                // >>> is arithmetic shift preserving sign
                step_count <= step_count + 1;
                if (step_count == 3) begin
                    rdy <= 1;
                    p <= product_acc[15:0]; // output lower 16 bits as product
                end
            end
        end
    end

endmodule