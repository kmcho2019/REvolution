module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Divide the 8-bit multiplicand into two 4-bit segments
wire [3:0] a_high = a[7:4];
wire [3:0] a_low = a[3:0];

// Create two parallel Radix-4 Booth multipliers
wire [15:0] p_high;
wire [15:0] p_low;

multi_booth_4bit u_high(
    .clk(clk),
    .reset(reset),
    .a(a_high),
    .b(b),
    .p(p_high)
);

multi_booth_4bit u_low(
    .clk(clk),
    .reset(reset),
    .a(a_low),
    .b(b),
    .p(p_low)
);

// Combine the outputs of the two parallel multipliers
assign p = p_high + (p_low << 4);

// Generate the ready signal
assign rdy = (u_high.rdy && u_low.rdy);

endmodule

module multi_booth_4bit(
    input clk,
    input reset,
    input [3:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

reg [15:0] multiplicand;
reg [15:0] multiplier;
reg [4:0] ctr;
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

// Pipelined multiplication process
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= { {12{b[7]}}, b };
        multiplier <= { {12{a[3]}}, a };
        p <= 0;
        ctr <= 0;
        rdy <= 0;
    end else if (enable) begin
        if (ctr < 16) begin
            // Left shift the multiplicand
            multiplicand <= multiplicand << 1;
            // Check the current bit of the multiplier
            if (multiplier[ctr] == 1) begin
                // Accumulate the product
                p <= p + multiplicand;
            end
            // Increment the counter
            ctr <= ctr + 1;
        end else if (ctr == 16) begin
            // Output the product and set the ready signal
            rdy <= 1;
            ctr <= 0;
        end
    end else if (!enable && ctr == 0) begin
        // Initialize the multiplicand and multiplier
        multiplicand <= { {12{b[7]}}, b };
        multiplier <= { {12{a[3]}}, a };
    end
end

endmodule