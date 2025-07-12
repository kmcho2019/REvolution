module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output rdy
);

    // Internal registers
    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [4:0] counter;  // 5-bit counter (0-15)
    reg prev_lsb;
    
    // State signal
    reg calculating;
    
    // Continuous assignments
    assign rdy = (counter == 5'd16);
    
    // Precompute partial products
    wire [15:0] pp_0 = 16'b0;
    wire [15:0] pp_A = multiplicand;
    wire [15:0] pp_2A = multiplicand << 1;
    wire [15:0] pp_negA = -multiplicand;
    wire [15:0] pp_neg2A = -(multiplicand << 1);
    
    // Booth encoding logic
    wire [2:0] booth_bits = {multiplier[1:0], prev_lsb};
    wire [15:0] partial_product = 
        (booth_bits == 3'b000 || booth_bits == 3'b111) ? pp_0 :
        (booth_bits == 3'b001 || booth_bits == 3'b010) ? pp_A :
        (booth_bits == 3'b011) ? pp_2A :
        (booth_bits == 3'b100) ? pp_neg2A :
        (booth_bits == 3'b101 || booth_bits == 3'b110) ? pp_negA :
        pp_0;
    
    // Shift amount for current iteration
    wire [3:0] shift_amount = counter[4:1] << 1;  // Multiply by 2
    
    // Main sequential logic
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            p <= 16'b0;
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            counter <= 5'b0;
            prev_lsb <= 1'b0;
            calculating <= 1'b1;
        end else begin
            if (calculating && !rdy) begin
                // Accumulate partial product
                p <= p + (partial_product << shift_amount);
                
                // Update multiplier and previous LSB
                multiplier <= multiplier >> 2;
                prev_lsb <= multiplier[1];
                
                // Increment counter
                counter <= counter + 1;
            end
            
            // Auto-reset when done
            if (rdy) begin
                calculating <= 1'b0;
            end
        end
    end

endmodule