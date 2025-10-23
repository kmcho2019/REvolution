module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal registers
    reg [16:0] multiplicand;  // 17-bit (16 + sign for shifts)
    reg [8:0] multiplier;     // 9-bit (8 + previous bit)
    reg [4:0] counter;        // 5-bit counter (0-15)
    
    // Booth encoding signals
    wire [2:0] booth_bits = {multiplier[1:0], multiplier[8]};
    wire [1:0] booth_sel;
    
    // Partial product selection
    wire [16:0] pp_x1 = multiplicand;
    wire [16:0] pp_x2 = {multiplicand[15:0], 1'b0};
    wire [16:0] pp_neg_x1 = ~multiplicand + 1;
    wire [16:0] pp_neg_x2 = ~{multiplicand[15:0], 1'b0} + 1;
    
    // Booth encoder
    assign booth_sel = (booth_bits == 3'b000 || booth_bits == 3'b111) ? 2'b00 :
                       (booth_bits == 3'b001 || booth_bits == 3'b010) ? 2'b01 :
                       (booth_bits == 3'b011) ? 2'b10 :
                       (booth_bits == 3'b100) ? 2'b11 : 2'b01;
    
    // Partial product mux
    wire [16:0] partial_product = 
        (booth_sel == 2'b00) ? 17'b0 :
        (booth_sel == 2'b01) ? (booth_bits[2] ? pp_neg_x1 : pp_x1) :
        (booth_sel == 2'b10) ? pp_x2 :
        pp_neg_x2;
    
    // Next product calculation
    wire [16:0] product_next = p + partial_product[16:1];

    always @(posedge clk) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{9{a[7]}}, a};
            multiplier <= {b, 1'b0};
            p <= 16'b0;
            counter <= 5'b0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            // Update product
            p <= product_next[15:0];
            
            // Shift multiplicand left by 2 (Radix-4)
            multiplicand <= multiplicand << 2;
            
            // Shift multiplier right by 2 (Radix-4)
            multiplier <= {2'b0, multiplier[8:2]};
            
            // Update counter and ready signal
            counter <= counter + 1;
            rdy <= (counter == 5'b1000);  // 8 steps for Radix-4 (8*2=16 bits)
        end
    end

endmodule