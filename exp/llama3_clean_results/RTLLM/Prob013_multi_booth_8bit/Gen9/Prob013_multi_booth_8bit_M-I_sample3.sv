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

// Separate always blocks for each register
always @(posedge clk or posedge reset) begin
    if(reset) begin
        multiplicand <= { {8{b[7]}}, b };
    end else if(ctr < 16) begin
        multiplicand <= multiplicand << 1;
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        multiplier <= { {8{a[7]}}, a };
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        ctr <= 0;
    end else if(ctr < 16) begin
        ctr <= ctr + 1;
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        p <= 0;
    end else if(ctr < 16) begin
        if(multiplier[ctr]) begin
            p <= p + multiplicand;
        end
    end
end

always @(posedge clk or posedge reset) begin
    if(reset) begin
        rdy <= 0;
    end else if(ctr == 16) begin
        rdy <= 1;
    end
end

endmodule