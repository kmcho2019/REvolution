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

// Initialize the registers
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        ctr <= 0;
        p <= 0;
        rdy <= 0;
    end else begin
        // Perform the multiplication process
        if (ctr < 16) begin
            // Left shift the multiplicand
            multiplicand <= multiplicand << 1;
            // Check the current bit of the multiplier
            if (multiplier[ctr] == 1) begin
                p <= p + multiplicand;
            end
            // Increment the counter
            ctr <= ctr + 1;
        end else begin
            // Set the ready signal
            rdy <= 1;
        end
    end
end

// Initialize the multiplicand and multiplier
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
    end
end

endmodule