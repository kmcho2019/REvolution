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
reg [15:0] partial_product1;
reg [15:0] partial_product2;
reg [15:0] product;
reg [4:0] ctr;
reg start;

always @(posedge clk) begin
    if (reset) begin
        multiplicand <= 0;
        multiplier <= 0;
        partial_product1 <= 0;
        partial_product2 <= 0;
        product <= 0;
        ctr <= 0;
        start <= 0;
        rdy <= 0;
    end else if (start) begin
        // Stage 1: Load multiplicand and multiplier
        if (ctr == 0) begin
            multiplicand <= {{8{b[7]}}, b};
            multiplier <= {{8{a[7]}}, a};
            ctr <= ctr + 1;
        end
        // Stage 2: Booth encoding and partial product generation
        else if (ctr == 1) begin
            if (multiplier[ctr] == 1) begin
                partial_product1 <= multiplicand;
            end
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
        end
        // Stage 3: Partial product accumulation
        else if (ctr == 2) begin
            if (multiplier[ctr] == 1) begin
                partial_product2 <= multiplicand;
            end
            product <= partial_product1 + partial_product2;
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
        end
        // Stage 4: Final addition and output
        else if (ctr == 3) begin
            product <= product + multiplicand;
            rdy <= 1;
            start <= 0;
        end
    end else begin
        start <= 1;
    end
end

assign p = product;

endmodule