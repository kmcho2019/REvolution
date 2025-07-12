module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [8:0] multiplier;    // Multiplier with extra bit for Booth
    reg [15:0] multiplicand; // Sign-extended multiplicand
    reg [15:0] accum;        // Accumulator for partial products
    reg [2:0] ctr;           // Counter (0-4 for 5 groups)
    reg [1:0] booth_bits;    // Current Booth group

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers with sign extension
            multiplier <= {b[7], b};
            multiplicand <= {{8{a[7]}}, a};
            accum <= 16'b0;
            ctr <= 3'b0;
            rdy <= 1'b0;
            p <= 16'b0;
        end else begin
            if (ctr < 5) begin
                // Get current Booth group (3 bits)
                booth_bits = multiplier[ctr*2 +: 2];
                if (ctr > 0) booth_bits[2] = multiplier[ctr*2-1]; // Include previous bit

                // Process current Booth group
                case (booth_bits)
                    3'b000, 3'b111: ; // No operation
                    3'b001, 3'b010: accum <= accum + (multiplicand << (ctr*2));
                    3'b011: accum <= accum + (multiplicand << (ctr*2 + 1));
                    3'b100: accum <= accum - (multiplicand << (ctr*2 + 1));
                    3'b101, 3'b110: accum <= accum - (multiplicand << (ctr*2));
                endcase

                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                // Multiplication complete
                p <= accum;
                rdy <= 1'b1;
                
                // Prepare for next operation
                multiplier <= {b[7], b};
                multiplicand <= {{8{a[7]}}, a};
                accum <= 16'b0;
                ctr <= 3'b0;
            end
        end
    end

endmodule