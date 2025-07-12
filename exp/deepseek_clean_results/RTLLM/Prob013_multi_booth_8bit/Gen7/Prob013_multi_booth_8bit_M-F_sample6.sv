module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;    // Sign-extended multiplicand
    reg [15:0] multiplier;      // Sign-extended multiplier with extra bit
    reg [4:0] ctr;              // 5-bit counter (0-15)
    reg [15:0] product;         // Accumulated product

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize registers on reset
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b, 1'b0}; // Extra bit for Booth encoding
            product <= 16'b0;
            ctr <= 5'b0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                // Booth encoding: examine 3 bits (multiplier[ctr+1:ctr-1])
                case (multiplier[ctr+1:ctr-1])
                    3'b000, 3'b111: ; // No operation (0)
                    3'b001, 3'b010: product <= product + (multiplicand << ctr); // +1
                    3'b011: product <= product + (multiplicand << (ctr+1));    // +2
                    3'b100: product <= product - (multiplicand << (ctr+1));    // -2
                    3'b101, 3'b110: product <= product - (multiplicand << ctr); // -1
                endcase

                ctr <= ctr + 2; // Radix-4 processes 2 bits at a time
            end else begin
                // Multiplication complete
                rdy <= 1'b1;
            end
        end
    end

    // Output the product when done
    always @(posedge clk) begin
        if (rdy) begin
            p <= product;
        end else begin
            p <= 16'b0;
        end
    end

endmodule