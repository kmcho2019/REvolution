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
        multiplicand <= {{8{b[7]}}, b};
        multiplier <= {{8{a[7]}}, a};
        product <= 0;
        ctr <= 0;
        rdy <= 0;
    end else if (enable) begin
        if (ctr < 16) begin
            if (multiplier[ctr] == 1) begin
                product <= product + multiplicand;
            end
            multiplicand <= multiplicand << 1;
            ctr <= ctr + 1;
        end else begin
            p <= product;
            rdy <= 1;
        end
    end
end

endmodule