module multi_booth_8bit(
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
reg [15:0] product;
reg [1:0] state;

// Clock gating to reduce power consumption
reg clk_enable;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0;
        clk_enable <= 0;
    end else begin
        case (state)
            0: begin
                // Reset the registers and set the initial state
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= 1;
                clk_enable <= 1;
            end
            1: begin
                // Perform the multiplication process
                if (clk_enable) begin
                    if (ctr < 16) begin
                        // Left shift the multiplicand
                        multiplicand <= multiplicand << 1;
                        // Check the current bit of the multiplier
                        if (multiplier[ctr] == 1) begin
                            // Accumulate the product
                            product <= product + multiplicand;
                        end
                        // Increment the counter
                        ctr <= ctr + 1;
                    end else begin
                        // Set the final state
                        state <= 2;
                        clk_enable <= 0;
                    end
                end
            end
            2: begin
                // Output the product and set the ready signal
                p <= product;
                rdy <= 1;
                state <= 0;
            end
            default: begin
                state <= 0;
            end
        endcase
    end
end

endmodule