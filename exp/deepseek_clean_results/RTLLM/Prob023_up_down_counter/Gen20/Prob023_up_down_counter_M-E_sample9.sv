module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Internal signals for parallel prefix computation
wire [15:0] p, g;  // propagate and generate
wire [15:0] c;     // carry out

// Compute propagate and generate signals
assign p = up_down ? 16'hFFFF : 16'h0000;  // All bits propagate for +1/-1
assign g = up_down ? count : ~count;        // Generate based on direction

// Kogge-Stone parallel prefix network
// First level
wire [15:0] p1, g1;
assign p1[0] = p[0];
assign g1[0] = g[0];
genvar i;
generate
    for (i = 1; i < 16; i = i + 1) begin : level1
        assign p1[i] = p[i] & p[i-1];
        assign g1[i] = (p[i] & g[i-1]) | g[i];
    end
endgenerate

// Second level
wire [15:0] p2, g2;
assign p2[1:0] = p1[1:0];
assign g2[1:0] = g1[1:0];
generate
    for (i = 2; i < 16; i = i + 1) begin : level2
        assign p2[i] = p1[i] & p1[i-2];
        assign g2[i] = (p1[i] & g1[i-2]) | g1[i];
    end
endgenerate

// Third level
wire [15:0] p3, g3;
assign p3[3:0] = p2[3:0];
assign g3[3:0] = g2[3:0];
generate
    for (i = 4; i < 16; i = i + 1) begin : level3
        assign p3[i] = p2[i] & p2[i-4];
        assign g3[i] = (p2[i] & g2[i-4]) | g2[i];
    end
endgenerate

// Fourth level
wire [15:0] p4, g4;
assign p4[7:0] = p3[7:0];
assign g4[7:0] = g3[7:0];
generate
    for (i = 8; i < 16; i = i + 1) begin : level4
        assign p4[i] = p3[i] & p3[i-8];
        assign g4[i] = (p3[i] & g3[i-8]) | g3[i];
    end
endgenerate

// Compute carries
assign c[0] = up_down;  // Carry-in is 1 for increment, 0 for decrement
assign c[15:1] = g4[14:0];

// Compute next count value
wire [15:0] next_count;
assign next_count = count ^ p ^ {c[14:0], up_down};

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule