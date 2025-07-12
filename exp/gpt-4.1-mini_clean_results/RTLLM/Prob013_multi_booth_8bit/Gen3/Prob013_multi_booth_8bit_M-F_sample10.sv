module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);
    reg [15:0] multiplicand;   // sign-extended multiplicand, shifted each cycle
    reg [15:0] multiplier;     // sign-extended multiplier
    reg [15:0] product;        // accumulated product
    reg [4:0] ctr;             // counts from 0 to 16

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // On reset, initialize registers
            multiplicand <= {{8{a[7]}}, a};  // sign-extend multiplicand
            multiplier <= {{8{b[7]}}, b};    // sign-extend multiplier
            product <= 16'd0;
            ctr <= 5'd0;
            p <= 16'd0;
            rdy <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[ctr] == 1'b1) begin
                    product <= product + multiplicand;
                end
                // Shift multiplicand left by 1 each cycle
                multiplicand <= multiplicand << 1;
                ctr <= ctr + 1;
            end else begin
                // Multiplication complete, output product and set ready
                p <= product;
                rdy <= 1'b1;
            end
        end
        // If rdy is high, retain outputs and registers until next reset
    end
endmodule