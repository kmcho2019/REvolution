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

// Pipelining: Break up the multiplication process into multiple stages
always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin
                // Initialize the multiplicand and multiplier registers
                multiplicand <= {{8{b[7]}}, b};
                multiplier <= {{8{a[7]}}, a};
                state <= 1;
            end
            1: begin
                // Multiply the multiplicand and multiplier
                if (ctr < 16) begin
                    // Left shift the multiplicand register
                    multiplicand <= multiplicand << 1;
                    // Add the multiplicand to the product if the current bit of the multiplier is 1
                    if (multiplier[ctr] == 1) begin
                        product <= product + multiplicand;
                    end
                    // Increment the counter
                    ctr <= ctr + 1;
                end else begin
                    state <= 2;
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

// Clock Gating: Disable the clock signal to idle components
always @(posedge clk) begin
    if (state == 0) begin
        // Disable the clock signal to the multiplicand and multiplier registers
        multiplicand <= multiplicand;
        multiplier <= multiplier;
    end
end

endmodule