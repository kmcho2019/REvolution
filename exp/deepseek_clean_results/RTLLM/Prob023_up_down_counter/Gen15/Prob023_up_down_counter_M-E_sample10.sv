module up_down_counter (
    input clk,
    input reset,
    input up_down,
    output reg [15:0] count
);

// Parallel prefix adder implementation with carry look-ahead
wire [15:0] next_count;
wire [15:0] operand_b = {16{up_down}}; // All 1's for increment, 0's for decrement
wire [15:0] inverted_count = ~count;
wire [15:0] adder_input_a = up_down ? count : inverted_count;

// Generate (G) and Propagate (P) signals
wire [15:0] G = adder_input_a & operand_b;
wire [15:0] P = adder_input_a ^ operand_b;

// Kogge-Stone parallel prefix carry computation
wire [15:0] C;

// First level
wire [15:1] G1, P1;
assign G1[1] = G[0];
assign P1[1] = P[0];
genvar i;
generate
    for (i = 1; i < 15; i = i + 1) begin : first_level
        assign G1[i+1] = G[i] | (P[i] & G1[i]);
        assign P1[i+1] = P[i] & P1[i];
    end
endgenerate

// Second level
wire [15:3] G2, P2;
generate
    for (i = 2; i < 15; i = i + 2) begin : second_level
        assign G2[i+1] = G1[i+1] | (P1[i+1] & G1[i-1]);
        assign P2[i+1] = P1[i+1] & P1[i-1];
    end
endgenerate

// Third level
wire [15:7] G3, P3;
generate
    for (i = 4; i < 15; i = i + 4) begin : third_level
        assign G3[i+3] = G2[i+3] | (P2[i+3] & G2[i-1]);
        assign P3[i+3] = P2[i+3] & P2[i-1];
    end
endgenerate

// Fourth level
wire [15:15] G4;
assign G4[15] = G3[15] | (P3[15] & G3[7]);

// Combine carry signals
assign C[0] = up_down; // Carry-in is 1 for increment, 0 for decrement
assign C[1] = G1[1] | (P1[1] & C[0]);
assign C[2] = G1[2] | (P1[2] & C[0]);
assign C[3] = G2[3] | (P2[3] & C[0]);
assign C[4] = G2[5] | (P2[5] & C[0]);
assign C[5] = G2[5] | (P2[5] & C[1]);
assign C[6] = G2[7] | (P2[7] & C[0]);
assign C[7] = G3[7] | (P3[7] & C[0]);
assign C[8] = G3[11] | (P3[11] & C[0]);
assign C[9] = G3[11] | (P3[11] & C[1]);
assign C[10] = G3[11] | (P3[11] & C[2]);
assign C[11] = G3[11] | (P3[11] & C[3]);
assign C[12] = G3[15] | (P3[15] & C[0]);
assign C[13] = G3[15] | (P3[15] & C[1]);
assign C[14] = G3[15] | (P3[15] & C[2]);
assign C[15] = G4[15];

// Sum computation
assign next_count = P ^ C;

always @(posedge clk) begin
    if (reset) begin
        count <= 16'h0000;
    end else begin
        count <= next_count;
    end
end

endmodule