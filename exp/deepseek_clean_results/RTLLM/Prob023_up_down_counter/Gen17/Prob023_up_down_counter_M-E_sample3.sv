module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

wire [15:0] operand = up_down ? 16'h0001 : 16'hFFFF; // +1 or -1 (2's complement)
wire [15:0] sum;

// Generate (G) and Propagate (P) signals
wire [15:0] G = count & operand;
wire [15:0] P = count ^ operand;

// Kogge-Stone parallel prefix network
// Stage 1: 1-bit span
wire [15:0] G1, P1;
assign G1[0] = G[0];
assign P1[0] = P[0];
genvar i;
generate
    for (i = 1; i < 16; i = i + 1) begin : stage1
        assign G1[i] = (P[i] & G[i-1]) | G[i];
        assign P1[i] = P[i] & P[i-1];
    end

    // Stage 2: 2-bit span
    wire [15:0] G2, P2;
    assign {G2[1:0], P2[1:0]} = {G1[1:0], P1[1:0]};
    for (i = 2; i < 16; i = i + 1) begin : stage2
        assign G2[i] = (P1[i] & G1[i-2]) | G1[i];
        assign P2[i] = P1[i] & P1[i-2];
    end

    // Stage 3: 4-bit span
    wire [15:0] G3, P3;
    assign {G3[3:0], P3[3:0]} = {G2[3:0], P2[3:0]};
    for (i = 4; i < 16; i = i + 1) begin : stage3
        assign G3[i] = (P2[i] & G2[i-4]) | G2[i];
        assign P3[i] = P2[i] & P2[i-4];
    end

    // Stage 4: 8-bit span
    wire [15:0] G4, P4;
    assign {G4[7:0], P4[7:0]} = {G3[7:0], P3[7:0]};
    for (i = 8; i < 16; i = i + 1) begin : stage4
        assign G4[i] = (P3[i] & G3[i-8]) | G3[i];
        assign P4[i] = P3[i] & P3[i-8];
    end
endgenerate

// Final carry computation
wire [15:0] C = {G4[14:0], 1'b0};

// Sum computation
assign sum = P ^ C;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= sum;
    end
end

endmodule