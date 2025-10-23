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
always @(posedge clk) begin
    if(reset) multiplicand <= { {8{b[7]}}, b };
    else multiplicand <= multiplicand << 1;
end

// Multiplier Register (MR)
reg [15:0] multiplier;
always @(posedge clk) begin
    if(reset) multiplier <= { {8{a[7]}}, a };
end

// Product Accumulator (PA)
reg [15:0] product;
always @(posedge clk) begin
    if(reset) product <= 0;
    else if(multiplier[0] == 1) product <= product + multiplicand;
end

// Control Unit (CU)
reg [4:0] ctr;
always @(posedge clk) begin
    if(reset) begin
        ctr <= 0;
        rdy <= 0;
    end else if(ctr < 16) begin
        ctr <= ctr + 1;
    end else begin
        rdy <= 1;
    end
end

// Booth Encoder (BE) and Update Logic
always @(posedge clk) begin
    if(reset) begin
        p <= 0;
    end else if(ctr < 16) begin
        if(multiplier[ctr]) begin
            p <= p + multiplicand;
        end
    end
end

endmodule