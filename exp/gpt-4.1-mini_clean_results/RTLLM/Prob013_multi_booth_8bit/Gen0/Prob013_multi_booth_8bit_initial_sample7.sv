module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [16:0] product;       // 17 bits: 16 product bits + 1 bit for previous multiplier bit (q-1)
    reg [15:0] multiplicand;  // Sign-extended multiplicand
    reg [4:0] ctr;            // Counter 0 to 16
    
    // Extract current and previous bits for Radix-4 Booth encoding
    wire [2:0] booth_bits = product[2:0]; // bits q0, q-1 and q1 in usual scheme, here 3 bits for decision

    // Helper function to perform addition or subtraction
    // The Radix-4 Booth algorithm works with 2 bits at a time, so the product register should be shifted accordingly.
    // However, from the problem statement, the approach is different. The problem statement is slightly ambiguous
    // about using Radix-4 or regular Booth.
    // The problem states: "If multiplier[ctr] == 1, add multiplicand to product; multiplicand is left shifted by 1 on each cycle."
    // This is a simple shift-add multiplier, not a Radix-4 Booth implementation as classically known.
    // To follow the exact instructions, we implement as per statement.

    reg [15:0] multiplier; // sign-extended multiplier (b)
    reg [7:0] a_reg, b_reg;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            a_reg <= a;
            b_reg <= b;
            multiplicand <= {{8{a[7]}}, a};   // Sign-extended a
            multiplier <= {{8{b[7]}}, b};     // Sign-extended b
            p <= 0;
            ctr <= 0;
            rdy <= 0;
        end else begin
            if (ctr < 16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[0] == 1'b1) begin
                    p <= p + multiplicand;
                end

                multiplicand <= multiplicand << 1; // left shift multiplicand by 1
                multiplier <= multiplier >> 1;     // right shift multiplier by 1
                ctr <= ctr + 1;
                rdy <= 0;
            end else begin
                rdy <= 1; // multiplication completed
            end
        end
    end
endmodule