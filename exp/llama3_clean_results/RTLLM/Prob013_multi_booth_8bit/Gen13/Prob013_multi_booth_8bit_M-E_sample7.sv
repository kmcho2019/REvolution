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
reg [15:0] product;
reg [4:0] ctr;
reg [15:0] temp;

// Stage 1: Initialization
always @(posedge clk) begin
    if (reset) begin
        multiplicand <= { {8{b[7]}}, b };
        multiplier <= { {8{a[7]}}, a };
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end
end

// Stage 2: Booth Encoding and Multiplicand Selection
always @(posedge clk) begin
    if (!reset && ctr < 16) begin
        if (multiplier[ctr] == 1) begin
            temp <= multiplicand;
        end else begin
            temp <= 0;
        end
        multiplicand <= multiplicand << 1;
        ctr <= ctr + 1;
    end
end

// Stage 3: Product Accumulation
always @(posedge clk) begin
    if (!reset && ctr < 16) begin
        product <= product + temp;
    end
end

// Stage 4: Final Product Calculation and Ready Signal Generation
always @(posedge clk) begin
    if (!reset && ctr == 16) begin
        p <= product;
        rdy <= 1;
    end
end

endmodule