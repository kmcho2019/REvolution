module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplier;   // initialized from 'a'
    reg [15:0] multiplicand; // initialized from 'b'
    reg [4:0] ctr;           // counts from 0 to 16

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs to 16-bit registers
            multiplier <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 0;
            rdy <= 0;
        end else begin
            if (ctr < 16) begin
                // If multiplier bit at ctr is 1, add multiplicand to p
                if (multiplier[ctr])
                    p <= p + multiplicand;

                // Shift multiplicand left by 1
                multiplicand <= multiplicand << 1;

                // Increment counter
                ctr <= ctr + 1;

                rdy <= 0;
            end else begin
                rdy <= 1; // multiplication complete
            end
        end
    end

endmodule