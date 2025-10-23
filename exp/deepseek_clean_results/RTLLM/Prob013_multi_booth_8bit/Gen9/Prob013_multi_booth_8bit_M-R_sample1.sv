module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [4:0] ctr;
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extended with sign bit
    reg [15:0] product;
    reg prev_bit;
    
    // Booth encoding wires
    wire [2:0] booth_bits = {multiplier[1:0], prev_bit};
    wire [15:0] partial_product;
    wire [15:0] multiplicand_x2 = {multiplicand[14:0], 1'b0};
    
    // Partial product selection (Radix-4 Booth)
    assign partial_product = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
        (booth_bits == 3'b011) ? multiplicand_x2 :
        (booth_bits == 3'b100) ? (~multiplicand_x2 + 1'b1) :
        (~multiplicand + 1'b1);  // For 101,110

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with sign-extended inputs
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b[7], b};
            product <= 16'b0;
            prev_bit <= 1'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            if (ctr < 5'd4) begin  // 4 iterations for 8-bit Radix-4
                // Accumulate partial product
                product <= product + partial_product;
                
                // Arithmetic shift right by 2 bits
                multiplier <= {multiplier[8], multiplier[8], multiplier[8:2]};
                prev_bit <= multiplier[1];
                
                // Update counter
                ctr <= ctr + 1;
                
                // Set output when done
                if (ctr == 5'd3) begin
                    p <= product + partial_product;
                    rdy <= 1'b1;
                end else begin
                    rdy <= 1'b0;
                end
            end else begin
                rdy <= 1'b1;  // Maintain ready signal
            end
        end
    end

endmodule