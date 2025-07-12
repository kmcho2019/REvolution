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
reg rdy_int;
reg enable;

// Clock gating
always @(posedge clk) begin
    if (reset) begin
        enable <= 0;
    end else if (ctr == 0) begin
        enable <= 1;
    end else if (ctr == 16) begin
        enable <= 0;
    end
end

// Reset the registers
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        rdy_int <= 0;
    end
end

// Perform the multiplication process
always @(posedge clk) begin
    if (enable) begin
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
            // Set the ready signal
            rdy_int <= 1;
        end
    end
end

// Set the output product and ready signal
always @(posedge clk) begin
    if (reset) begin
        p <= 0;
        rdy <= 0;
    end else if (rdy_int) begin
        p <= product;
        rdy <= 1;
    end
end

// Initialize the multiplier and multiplicand
always @(posedge clk) begin
    if (reset) begin
        multiplier <= 0;
        multiplicand <= 0;
    end else if (enable && ctr == 0) begin
        multiplier <= {{8{a[7]}}, a};
        multiplicand <= {{8{b[7]}}, b};
    end
end

endmodule