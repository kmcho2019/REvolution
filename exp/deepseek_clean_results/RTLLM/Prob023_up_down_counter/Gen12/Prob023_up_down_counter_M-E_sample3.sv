module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Parallel prefix adder implementation for increment/decrement
wire [15:0] next_count;
wire [15:0] operand = up_down ? 16'h0001 : 16'hFFFF; // +1 for up, -1 for down

// Generate and propagate carries using Kogge-Stone structure
wire [15:0] g, p;
wire [15:0] carry;

// Generate (g) and propagate (p) signals
assign g = count & operand;
assign p = count ^ operand;

// Carry computation stages
// Stage 1: 1-bit span
wire [15:0] g1, p1;
assign g1[0] = g[0];
assign p1[0] = p[0];
genvar i;
generate
    for (i = 1; i < 16; i = i + 1) begin : stage1
        assign g1[i] = g[i] | (p[i] & g[i-1]);
        assign p1[i] = p[i] & p[i-1];
    end
endgenerate

// Stage 2: 2-bit span
wire [15:0] g2, p2;
assign g2[1:0] = g1[1:0];
assign p2[1:0] = p1[1:0];
generate
    for (i = 2; i < 16; i = i + 1) begin : stage2
        assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
        assign p2[i] = p1[i] & p1[i-2];
    end
endgenerate

// Stage 3: 4-bit span
wire [15:0] g3, p3;
assign g3[3:0] = g2[3:0];
assign p3[3:0] = p2[3:0];
generate
    for (i = 4; i < 16; i = i + 1) begin : stage3
        assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
        assign p3[i] = p2[i] & p2[i-4];
    end
endgenerate

// Stage 4: 8-bit span
wire [15:0] g4, p4;
assign g4[7:0] = g3[7:0];
assign p4[7:0] = p3[7:0];
generate
    for (i = 8; i < 16; i = i + 1) begin : stage4
        assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
        assign p4[i] = p3[i] & p3[i-8];
    end
endgenerate

// Final carry computation
assign carry[0] = up_down; // Carry-in is 1 for increment, 0 for decrement
assign carry[15:1] = g4[14:0] | (p4[14:0] & {carry[14:0]});

// Sum computation
assign next_count = p ^ carry;

// Register update
always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule