module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;
    reg [15:0] multiplier;
    reg [15:0] product;
    reg [2:0] counter;
    reg [1:0] lsb_pair;
    
    wire [15:0] multiplicand_x2 = {multiplicand[14:0], 1'b0};
    wire [15:0] multiplicand_neg = ~multiplicand + 1;
    wire [15:0] multiplicand_x2_neg = ~multiplicand_x2 + 1;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign extension
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            product <= 16'b0;
            counter <= 3'b0;
            rdy <= 1'b0;
        end else begin
            if (counter < 4) begin
                // Get current 2-bit pair plus previous LSB
                lsb_pair = (counter == 0) ? {multiplier[1:0], 1'b0} : 
                          {multiplier[2*counter+1:2*counter], multiplier[2*counter-1]};
                
                // Booth encoding and partial product selection
                case (lsb_pair)
                    3'b000, 3'b111: product <= product;
                    3'b001, 3'b010: product <= product + multiplicand;
                    3'b011:         product <= product + multiplicand_x2;
                    3'b100:         product <= product + multiplicand_x2_neg;
                    3'b101, 3'b110: product <= product + multiplicand_neg;
                endcase
                
                // Arithmetic right shift multiplier by 2 (Radix-4)
                multiplier <= $signed(multiplier) >>> 2;
                
                // Left shift multiplicand by 2 for next partial product
                multiplicand <= multiplicand << 2;
                
                counter <= counter + 1;
                rdy <= 1'b0;
            end else begin
                // Multiplication complete
                p <= product;
                rdy <= 1'b1;
            end
        end
    end

endmodule