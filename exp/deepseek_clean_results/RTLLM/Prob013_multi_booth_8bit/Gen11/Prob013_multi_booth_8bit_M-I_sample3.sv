module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [1:0] counter;  // 0-3 cycles for 8-bit Radix-4 (4 iterations)
    reg [15:0] multiplicand;
    reg [9:0] multiplier;  // Extended with 2 bits (sign + previous)
    reg [15:0] product;
    
    // Booth encoding (Radix-4)
    wire [2:0] booth_bits = multiplier[2:0];
    wire [15:0] partial_product;
    
    // Partial product selection
    assign partial_product = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? 16'b0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? multiplicand :
        (booth_bits == 3'b011) ? {multiplicand[14:0], 1'b0} :  // 2*M
        (booth_bits == 3'b100) ? ~({multiplicand[14:0], 1'b0}) + 1'b1 :  // -2*M
        (booth_bits == 3'b101 || booth_bits == 3'b110) ? ~multiplicand + 1'b1 :  // -M
        16'b0;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {b[7], b, 1'b0};  // Sign bit + multiplier + 0
            product <= 16'b0;
            counter <= 2'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            if (!rdy) begin
                // Accumulate partial product
                product <= product + partial_product;
                
                // Arithmetic shift right by 2 bits
                multiplier <= {multiplier[9], multiplier[9], multiplier[9:2]};
                
                // Update counter
                counter <= counter + 1;
                
                // Check completion
                if (counter == 2'b11) begin
                    rdy <= 1'b1;
                    p <= product + partial_product;
                end
            end
        end
    end

endmodule