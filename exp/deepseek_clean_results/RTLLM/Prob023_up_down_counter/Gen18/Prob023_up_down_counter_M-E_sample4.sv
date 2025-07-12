module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Gray code conversion functions
function [3:0] bin2gray(input [3:0] bin);
    bin2gray = bin ^ (bin >> 1);
endfunction

function [3:0] gray2bin(input [3:0] gray);
    gray2bin = {gray[3], 
               gray[3] ^ gray[2],
               gray[3] ^ gray[2] ^ gray[1],
               gray[3] ^ gray[2] ^ gray[1] ^ gray[0]};
endfunction

// Segment the counter into 4-bit gray-coded segments
reg [3:0] seg0_gray, seg1_gray, seg2_gray, seg3_gray;
wire [3:0] seg0_bin = gray2bin(seg0_gray);
wire [3:0] seg1_bin = gray2bin(seg1_gray);
wire [3:0] seg2_bin = gray2bin(seg2_gray);
wire [3:0] seg3_bin = gray2bin(seg3_gray);

// Boundary conditions for each segment
wire seg0_max = (seg0_bin == 4'hF);
wire seg0_min = (seg0_bin == 4'h0);
wire seg1_max = (seg1_bin == 4'hF);
wire seg1_min = (seg1_bin == 4'h0);
wire seg2_max = (seg2_bin == 4'hF);
wire seg2_min = (seg2_bin == 4'h0);

// Predictive carry generation
wire carry0 = up_down ? seg0_max : seg0_min;
wire carry1 = up_down ? (seg0_max & seg1_max) : (seg0_min & seg1_min);
wire carry2 = up_down ? (seg0_max & seg1_max & seg2_max) : (seg0_min & seg1_min & seg2_min);

// Clock gating signals
wire seg0_en = ~reset;
wire seg1_en = seg0_en & (carry0 | ~(up_down ? seg0_max : seg0_min));
wire seg2_en = seg1_en & (carry1 | ~(up_down ? seg1_max : seg1_min));
wire seg3_en = seg2_en & (carry2 | ~(up_down ? seg2_max : seg2_min));

// Gated clocks
wire seg0_clk = clk & seg0_en;
wire seg1_clk = clk & seg1_en;
wire seg2_clk = clk & seg2_en;
wire seg3_clk = clk & seg3_en;

// Segment counters (gray-coded)
always @(posedge seg0_clk or posedge reset) begin
    if (reset) begin
        seg0_gray <= 4'h0;
    end else begin
        seg0_gray <= bin2gray(up_down ? gray2bin(seg0_gray) + 1 : gray2bin(seg0_gray) - 1);
    end
end

always @(posedge seg1_clk or posedge reset) begin
    if (reset) begin
        seg1_gray <= 4'h0;
    end else begin
        seg1_gray <= bin2gray(up_down ? gray2bin(seg1_gray) + 1 : gray2bin(seg1_gray) - 1);
    end
end

always @(posedge seg2_clk or posedge reset) begin
    if (reset) begin
        seg2_gray <= 4'h0;
    end else begin
        seg2_gray <= bin2gray(up_down ? gray2bin(seg2_gray) + 1 : gray2bin(seg2_gray) - 1);
    end
end

always @(posedge seg3_clk or posedge reset) begin
    if (reset) begin
        seg3_gray <= 4'h0;
    end else begin
        seg3_gray <= bin2gray(up_down ? gray2bin(seg3_gray) + 1 : gray2bin(seg3_gray) - 1);
    end
end

// Output binary conversion
always @(*) begin
    count = {gray2bin(seg3_gray), gray2bin(seg2_gray), 
             gray2bin(seg1_gray), gray2bin(seg0_gray)};
end

endmodule