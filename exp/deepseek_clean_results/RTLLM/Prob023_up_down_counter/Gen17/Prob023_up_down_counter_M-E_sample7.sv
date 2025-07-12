module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] delta = {16{up_down}} ^ 16'h0001; // 1 for up, -1 (2's comp) for down
wire [15:0] next_count;

// Parallel prefix adder (Kogge-Stone)
wire [15:0] p = count ^ delta;
wire [15:0] g = count & delta;

// First level
wire [15:0] g1, p1;
assign g1[0] = g[0];
assign p1[0] = p[0];
genvar i;
generate
    for (i = 1; i < 16; i = i + 1) begin : level1
        assign g1[i] = g[i] | (p[i] & g[i-1]);
        assign p1[i] = p[i] & p[i-1];
    end
endgenerate

// Second level
wire [15:0] g2, p2;
assign g2[1:0] = g1[1:0];
assign p2[1:0] = p1[1:0];
generate
    for (i = 2; i < 16; i = i + 1) begin : level2
        assign g2[i] = g1[i] | (p1[i] & g1[i-2]);
        assign p2[i] = p1[i] & p1[i-2];
    end
endgenerate

// Third level
wire [15:0] g3, p3;
assign g3[3:0] = g2[3:0];
assign p3[3:0] = p2[3:0];
generate
    for (i = 4; i < 16; i = i + 1) begin : level3
        assign g3[i] = g2[i] | (p2[i] & g2[i-4]);
        assign p3[i] = p2[i] & p2[i-4];
    end
endgenerate

// Fourth level
wire [15:0] g4, p4;
assign g4[7:0] = g3[7:0];
assign p4[7:0] = p3[7:0];
generate
    for (i = 8; i < 16; i = i + 1) begin : level4
        assign g4[i] = g3[i] | (p3[i] & g3[i-8]);
        assign p4[i] = p3[i] & p3[i-8];
    end
endgenerate

// Compute carries and final sum
wire [15:0] carry = {g4[14:0], 1'b0};
assign next_count = p ^ carry;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule