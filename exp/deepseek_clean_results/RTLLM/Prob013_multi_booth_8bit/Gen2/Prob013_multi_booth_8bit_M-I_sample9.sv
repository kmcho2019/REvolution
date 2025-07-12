module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    // Internal registers
    reg [15:0] multiplicand;  // Sign-extended A
    reg [15:0] multiplier;    // Sign-extended B
    reg [1:0] counter;        // 2-bit counter (0-3)
    reg prev_lsb;             // Previous LSB for Booth encoding
    
    // Pre-computed partial products
    wire [15:0] pp_0 = 16'b0;
    wire [15:0] pp_A = multiplicand;
    wire [15:0] pp_2A = multiplicand << 1;
    wire [15:0] pp_negA = -multiplicand;
    wire [15:0] pp_neg2A = -(multiplicand << 1);
    
    // Booth encoder (3-bit window)
    wire [2:0] booth_bits = {multiplier[1:0], prev_lsb};
    
    // Selected partial product
    reg [15:0] partial_product;
    
    always @* begin
        case (booth_bits)
            3'b000, 3'b111: partial_product = pp_0;
            3'b001, 3'b010: partial_product = pp_A;
            3'b011:         partial_product = pp_2A;
            3'b100:         partial_product = pp_neg2A;
            3'b101, 3'b110: partial_product = pp_negA;
            default:        partial_product = pp_0;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize with sign-extended inputs
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            p <= 16'b0;
            rdy <= 1'b0;
            counter <= 2'b0;
            prev_lsb <= 1'b0;
        end else if (!rdy) begin
            if (counter < 4) begin
                // Accumulate partial product (shifted by 2*counter bits)
                p <= p + (partial_product << (counter * 2));
                
                // Shift multiplier right by 2 bits for next group
                multiplier <= multiplier >> 2;
                prev_lsb <= multiplier[1];
                
                // Increment counter
                counter <= counter + 1;
            end
            
            // Set ready signal after 4 iterations
            if (counter == 3)
                rdy <= 1'b1;
        end
    end

endmodule