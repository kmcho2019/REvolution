module multi_booth_8bit(
    input clk,
    input reset,
    input [7:0] a,
    input [7:0] b,
    output reg [15:0] p,
    output reg rdy
);

// Multiplicand Shift Register (MSR)
reg [15:0] multiplicand;
always @(posedge clk or posedge reset) begin
    if(reset) multiplicand <= { {8{b[7]}}, b };
    else multiplicand <= multiplicand << 1;
end

// Multiplier Register (MR)
reg [15:0] multiplier;
always @(posedge clk or posedge reset) begin
    if(reset) multiplier <= { {8{a[7]}}, a };
end

// Product Accumulator (PA) using carry-save adder
reg [15:0] product;
reg [15:0] carry;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        product <= 0;
        carry <= 0;
    end else if(multiplier[0] == 1) begin
        product <= product + multiplicand;
        carry <= carry + (product[15] & multiplicand[15]);
    end
end

// Control Unit (CU) with clock gating
reg [4:0] ctr;
reg clk_en;
always @(posedge clk or posedge reset) begin
    if(reset) begin
        ctr <= 0;
        rdy <= 0;
        clk_en <= 1'b1;
    end else if(ctr < 16) begin
        ctr <= ctr + 1;
        clk_en <= 1'b1;
    end else begin
        rdy <= 1;
        clk_en <= 1'b0;
    end
end

// Booth Encoder (BE) and Update Logic
always @(posedge clk) begin
    if(clk_en) begin
        if(multiplier[ctr]) begin
            p <= p + multiplicand;
        end
    end
end

endmodule