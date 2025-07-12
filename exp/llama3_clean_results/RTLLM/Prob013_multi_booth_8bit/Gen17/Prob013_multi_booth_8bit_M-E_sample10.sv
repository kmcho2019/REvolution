module multi_booth_8bit_pipelined(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Stage 1: Sign Extension
reg [15:0] sign_extended_a;
reg [15:0] sign_extended_b;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        sign_extended_a <= 0;
        sign_extended_b <= 0;
    end else begin
        sign_extended_a <= {{8{a[7]}}, a};
        sign_extended_b <= {{8{b[7]}}, b};
    end
end

// Stage 2: Multiplier Preparation
reg [15:0] prepared_multiplier;
always @(posedge clk) begin
    prepared_multiplier <= sign_extended_a;
end

// Stage 3: Multiplicand Shifting and Accumulation
reg [15:0] multiplicand;
reg [15:0] product;
reg [4:0] ctr;
always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= 0;
        product <= 0;
        ctr <= 0;
    end else if (ctr < 16) begin
        multiplicand <= multiplicand << 1;
        if (prepared_multiplier[ctr]) begin
            product <= product + multiplicand;
        end
        ctr <= ctr + 1;
    end
end

// Stage 4: Product Finalization
always @(posedge clk) begin
    if (ctr == 16) begin
        p <= product;
        rdy <= 1;
    end else begin
        rdy <= 0;
    end
end

// Clock Gating
// Each stage can be independently gated to reduce power consumption
// when the multiplier is idle.

endmodule