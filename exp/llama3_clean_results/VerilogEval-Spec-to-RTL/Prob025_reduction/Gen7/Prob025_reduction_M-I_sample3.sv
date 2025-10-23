module TopModule(
    input  [7:0] in,  // 8-bit input
    output reg parity  // 1-bit parity output
);

// Calculate the parity bit using a tree-like structure
always @(*) begin
    reg [7:0] temp1;
    reg [3:0] temp2;
    reg [1:0] temp3;

    // Level 1: Pairwise XOR of adjacent bits
    temp1[0] = in[0] ^ in[1];
    temp1[1] = in[2] ^ in[3];
    temp1[2] = in[4] ^ in[5];
    temp1[3] = in[6] ^ in[7];

    // Level 2: XOR of the results from Level 1
    temp2[0] = temp1[0] ^ temp1[1];
    temp2[1] = temp1[2] ^ temp1[3];

    // Level 3: XOR of the results from Level 2
    temp3[0] = temp2[0] ^ temp2[1];

    // Final XOR operation
    parity = temp3[0];
end

endmodule