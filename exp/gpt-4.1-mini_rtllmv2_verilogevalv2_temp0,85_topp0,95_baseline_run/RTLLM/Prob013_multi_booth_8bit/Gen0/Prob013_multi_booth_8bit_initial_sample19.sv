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
    reg [4:0] ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs a and b to 16 bits and store
            multiplicand <= {{8{a[7]}}, a};
            multiplier   <= {{8{b[7]}}, b};
            p            <= 16'b0;
            ctr          <= 0;
            rdy          <= 0;
        end else begin
            if (ctr < 16) begin
                // If current multiplier bit is 1, add multiplicand to product
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                // Left shift multiplicand by 1 each cycle
                multiplicand <= multiplicand << 1;
                // Increment counter
                ctr <= ctr + 1;
                // Ready not yet asserted
                rdy <= 0;
            end else begin
                // Multiplication complete
                rdy <= 1;
            end
        end
    end

endmodule