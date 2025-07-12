module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output [15:0] count,
    output [15:0] gray_count // Optional Gray code output
);

reg [15:0] count_reg;
reg [15:0] next_count;
wire count_enable = ~reset; // Clock gating enable

// Kogge-Stone parallel prefix adder/subtractor logic
wire [15:0] operand = up_down ? 16'h0001 : 16'hFFFF;
wire [15:0] gen, prop;
wire [15:0] carry;

// Generate and propagate terms
assign gen = count_reg & operand;
assign prop = count_reg ^ operand;

// Carry computation stages (Kogge-Stone)
wire [15:0] g1, p1;
assign g1[0] = gen[0];
assign p1[0] = prop[0];
genvar i;
for (i = 1; i < 16; i = i + 1) begin
    assign g1[i] = gen[i] | (prop[i] & gen[i-1]);
    assign p1[i] = prop[i] & prop[i-1];
end

wire [15:0] g2, p2;
assign g2[0] = g1[0];
assign g2[1] = g1[1];
assign p2[0] = p1[0];
assign p2[1] = p1[1];
for (i = 2; i < 16; i = i + 1) begin
    assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
    assign p2[i] = p1[i] & p1[i-2];
end

wire [15:0] g3, p3;
assign g3[0] = g2[0];
assign g3[1] = g2[1];
assign g3[2] = g2[2];
assign g3[3] = g2[3];
assign p3[0] = p2[0];
assign p3[1] = p2[1];
assign p3[2] = p2[2];
assign p3[3] = p2[3];
for (i = 4; i < 16; i = i + 1) begin
    assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
    assign p3[i] = p2[i] & p2[i-4];
end

wire [15:0] g4, p4;
assign g4[0] = g3[0];
assign g4[1] = g3[1];
assign g4[2] = g3[2];
assign g4[3] = g3[3];
assign g4[4] = g3[4];
assign g4[5] = g3[5];
assign g4[6] = g3[6];
assign g4[7] = g3[7];
assign p4[0] = p3[0];
assign p4[1] = p3[1];
assign p4[2] = p3[2];
assign p4[3] = p3[3];
assign p4[4] = p3[4];
assign p4[5] = p3[5];
assign p4[6] = p3[6];
assign p4[7] = p3[7];
for (i = 8; i < 16; i = i + 1) begin
    assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
    assign p4[i] = p3[i] & p3[i-8];
end

// Final carry computation
assign carry[0] = 1'b0;
for (i = 1; i < 16; i = i + 1) begin
    assign carry[i] = g4[i-1];
end

// Sum computation
assign next_count = prop ^ carry;

// Clock gated register update
always @(posedge clk or posedge reset) begin
    if (reset) begin
        count_reg <= 16'b0;
    end else if (count_enable) begin
        count_reg <= next_count;
    end
end

// Gray code conversion
assign gray_count = count_reg ^ (count_reg >> 1);
assign count = count_reg;

endmodule