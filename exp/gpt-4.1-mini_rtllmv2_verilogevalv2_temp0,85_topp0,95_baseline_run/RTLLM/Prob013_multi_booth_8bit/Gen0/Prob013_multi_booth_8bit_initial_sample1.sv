module multi_booth_8bit (
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplier;
    reg [15:0] multiplicand;
    reg [4:0] ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Initialize multiplier and multiplicand with sign extension as per user spec
            multiplier <= {{8{a[7]}}, a};
            multiplicand <= {{8{b[7]}}, b};
            p <= 16'b0;
            ctr <= 0;
            rdy <= 1'b0;
        end else begin
            if (ctr < 16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                // Shift multiplicand left by 1
                multiplicand <= multiplicand << 1;
                // Increment counter
                ctr <= ctr + 1;
                rdy <= 1'b0;
            end else begin
                rdy <= 1'b1;
            end
        end
    end

endmodule