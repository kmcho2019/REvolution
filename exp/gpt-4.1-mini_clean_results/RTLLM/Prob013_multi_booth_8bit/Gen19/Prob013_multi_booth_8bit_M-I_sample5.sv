module multi_booth_8bit (
    input              clk,
    input              reset,
    input      [7:0]   a,      // multiplicand
    input      [7:0]   b,      // multiplier
    output reg [15:0]  p,      // product output
    output reg         rdy      // ready signal
);

    // Internal registers:
    // product is 17 bits wide to accommodate shifts and additions
    reg signed [16:0] product;        // holds intermediate product with extra bit for sign extension
    reg signed [16:0] multiplicand;   // sign-extended multiplicand shifted as needed
    reg [8:0]         booth_mult;     // multiplier bits + appended zero bit for Booth encoding (9 bits)
    reg [3:0]         count;           // iteration counter: 0 to 7 (8 iterations)

    // Partial product according to Booth encoding (+2*MCAND, +1*MCAND, 0, -1*MCAND, -2*MCAND)
    reg signed [16:0] pp; 

    wire [2:0] booth_bits; // Current 3-bit slice for Booth encoding

    // Extract 3 bits for current cycle: bits [2*count+1 : 2*count -1], zero-extended at LSB
    assign booth_bits = booth_mult[2*count +: 3];

    // Booth recoding combinational logic:
    // Mapping:
    // 000 ->  0
    // 001 -> +1
    // 010 -> +1
    // 011 -> +2
    // 100 -> -2
    // 101 -> -1
    // 110 -> -1
    // 111 ->  0

    always @(*) begin
        case (booth_bits)
            3'b000, 3'b111: pp = 17'sd0;
            3'b001,
            3'b010: pp = multiplicand;
            3'b011: pp = multiplicand <<< 1; // +2 * multiplicand
            3'b100: pp = - (multiplicand <<< 1); // -2 * multiplicand
            3'b101,
            3'b110: pp = -multiplicand;
            default: pp = 17'sd0; // Should not occur
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset:
            // Sign-extend multiplicand (a) and multiplier (b)
            // Build the Booth multiplier register with appended 0 bit at LSB
            multiplicand <= {{9{a[7]}}, a};   // 17 bits: 9 bits sign + 8 bits input
            booth_mult   <= {b, 1'b0};        // 9 bits, b[7:0] + appended 0 at LSB
            product      <= 17'sd0;
            count        <= 4'd0;
            rdy          <= 1'b0;
            p            <= 16'd0;
        end else if (!rdy) begin
            if (count < 4'd8) begin
                // Add partial product shifted appropriately
                product <= (product >>> 2) + pp; // arithmetic right shift by 2, add partial product
                count <= count + 1;
            end else begin
                // Multiplication done
                rdy <= 1'b1;
                p <= product[15:0]; // Output lower 16 bits as final product
            end
        end
    end

endmodule