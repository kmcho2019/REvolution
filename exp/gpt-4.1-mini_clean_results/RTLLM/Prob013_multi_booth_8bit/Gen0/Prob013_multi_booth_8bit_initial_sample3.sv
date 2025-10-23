module multi_booth_8bit (
    input wire clk,
    input wire reset,
    input wire [7:0] a,
    input wire [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

    reg [15:0] multiplicand;  // Extended multiplicand (a)
    reg [15:0] multiplier;    // Extended multiplier (b)
    reg [4:0] ctr;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Sign-extend inputs a and b to 16 bits
            multiplicand <= {{8{a[7]}}, a};
            multiplier   <= {{8{b[7]}}, b};
            p            <= 16'd0;
            ctr          <= 5'd0;
            rdy          <= 1'b0;
        end else if (!rdy) begin
            if (ctr < 16) begin
                // If multiplier bit at position ctr is 1, add multiplicand to p
                if (multiplier[ctr]) begin
                    p <= p + multiplicand;
                end
                // Left shift multiplicand by 1
                multiplicand <= multiplicand << 1;
                // Increment counter
                ctr <= ctr + 1'b1;
            end
            if (ctr == 16) begin
                // Set ready signal high after multiplication complete
                rdy <= 1'b1;
            end
        end
    end

endmodule