module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Counter for Radix-4 steps (0-3 for 8 bits)
    reg [2:0] counter;
    
    // Working registers
    reg [15:0] multiplicand;
    reg [8:0] multiplier;  // Extended with sign bit
    reg [15:0] product;
    reg prev_bit;
    
    // Sign-extended inputs
    wire [15:0] a_ext = {{8{a[7]}}, a};
    wire [8:0] b_ext = {b[7], b};
    
    // Booth encoding bits (Radix-4)
    wire [2:0] booth_bits = {multiplier[1:0], prev_bit};
    
    // Partial product calculation
    wire [15:0] partial_product;
    assign partial_product = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
        (booth_bits == 3'b011) ? {multiplicand[14:0], 1'b0} :  // 2*M
        (booth_bits == 3'b100) ? ~({multiplicand[14:0], 1'b0}) + 1'b1 :  // -2*M
        (booth_bits == 3'b101 || booth_bits == 3'b110) ? ~multiplicand + 1'b1 :  // -M
        16'b0;

    // Ready signal logic
    wire computation_done = (counter == 3'b100);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= a_ext;
            multiplier <= b_ext;
            product <= 16'b0;
            prev_bit <= 1'b0;
            counter <= 3'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            if (!computation_done) begin
                // Accumulate partial product
                product <= product + partial_product;
                
                // Arithmetic shift right by 2 bits
                multiplier <= {multiplier[8], multiplier[8], multiplier[8:2]};
                prev_bit <= multiplier[1];
                
                // Update counter
                counter <= counter + 1;
            end
            
            // Final result capture
            if (computation_done) begin
                p <= product + partial_product;
                rdy <= 1'b1;
            end else begin
                rdy <= 1'b0;
            end
        end
    end

endmodule