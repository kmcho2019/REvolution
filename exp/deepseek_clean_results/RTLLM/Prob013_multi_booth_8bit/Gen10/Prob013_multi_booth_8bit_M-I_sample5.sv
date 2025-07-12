module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [2:0] ctr;          // 3-bit counter for 4 iterations
    reg [15:0] multiplicand;
    reg [8:0] multiplier;   // Extended with sign bit
    reg [15:0] product;
    reg prev_bit;
    
    // Booth encoding wires
    wire [2:0] booth_bits = {multiplier[1:0], prev_bit};
    wire [15:0] partial_product;
    wire [15:0] multiplicand_x2 = {multiplicand[14:0], 1'b0};
    wire [15:0] multiplicand_neg = ~multiplicand + 1'b1;
    wire [15:0] multiplicand_x2_neg = ~multiplicand_x2 + 1'b1;
    
    // Partial product selection (Radix-4 Booth)
    assign partial_product = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
        (booth_bits == 3'b011) ? multiplicand_x2 :
        (booth_bits == 3'b100) ? multiplicand_x2_neg :
        multiplicand_neg;  // For 101,110

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with sign-extended inputs
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b[7], b};
            product <= 16'b0;
            prev_bit <= 1'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            if (!rdy) begin
                // Accumulate partial product
                product <= product + partial_product;
                
                // Arithmetic shift right by 2 bits
                multiplier <= {{2{multiplier[8]}}, multiplier[8:2]};
                prev_bit <= multiplier[1];
                
                // Update counter
                ctr <= ctr + 1;
                
                // Set output when done
                if (ctr == 3'd3) begin
                    p <= product + partial_product;
                    rdy <= 1'b1;
                end
            end
        end
    end

endmodule