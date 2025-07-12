module multi_booth_8bit(
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [4:0] ctr;               // Counter for 16 bits
    reg signed [15:0] multiplicand; // Sign-extended multiplicand
    reg signed [15:0] multiplier;   // Sign-extended multiplier
    reg signed [31:0] product;       // Extended product register (to avoid overflow during addition)

    // Synchronous logic for reset and multiplication process
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign extend inputs to 16 bits
            multiplicand <= {{8{a[7]}}, a};
            multiplier <= {{8{b[7]}}, b};
            product <= 32'sd0; // clear product
            ctr <= 5'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 5'd16) begin
                // Check current multiplier bit
                if (multiplier[ctr] == 1'b1) begin
                    // Add multiplicand shifted by ctr to product
                    // Actually we implement it by shifting multiplicand left by ctr bits
                    // But as per problem, multiplicand is shifted each cycle by 1; here we do direct addition
                    product <= product + (multiplicand <<< ctr);
                end
                // Increment counter
                ctr <= ctr + 1'b1;

                if (ctr == 5'd15) begin
                    // On the last cycle (ctr=15), prepare output and set ready
                    p <= product[15:0];
                    rdy <= 1'b1;
                end
            end else begin
                // After operation done, hold output and ready
                p <= product[15:0];
                rdy <= 1'b1;
            end
        end
    end

endmodule