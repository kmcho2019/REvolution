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

// Stage 1: Initialization
always @(posedge clk or posedge reset) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        product <= 0;
        ctr <= 0;
        rdy <= 0;
        state <= 0;
    end else if (state == 0) begin
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        state <= 1;
    end
end

// Stage 2: Booth Encoding and Partial Product Selection
reg [15:0] partial_product;
always @(posedge clk) begin
    if (state == 1) begin
        partial_product <= (multiplier[ctr] == 1) ? multiplicand : 0;
        state <= 2;
    end
end

// Stage 3: Partial Product Accumulation and Final Result
always @(posedge clk) begin
    if (state == 2) begin
        product <= product + partial_product;
        multiplicand <= multiplicand << 1;
        ctr <= ctr + 1;
        if (ctr >= 16) begin
            state <= 3;
        end else begin
            state <= 1;
        end
    end else if (state == 3) begin
        p <= product;
        rdy <= 1;
        state <= 0;
    end
end

// Dynamic Clock Gating
reg clk_gate;
always @(posedge clk) begin
    clk_gate <= (state == 1 || state == 2) ? 1 : 0;
end

// Clock Gating for Each Stage
reg clk_stage1, clk_stage2, clk_stage3;
always @(posedge clk) begin
    clk_stage1 <= clk_gate && (state == 0);
    clk_stage2 <= clk_gate && (state == 1);
    clk_stage3 <= clk_gate && (state == 2);
end

endmodule