module TopModule (
    input [3:0] in,
    output [3:0] out_both,
    output [3:0] out_any,
    output [3:0] out_different
);

    wire [3:0] left_neighbor = {in[0], in[3:1]};  // Shared rotated vector
    
    assign out_both[2:0] = in[2:0] & left_neighbor[2:0];  // Only assign needed bits
    assign out_any[3:1] = in[3:1] | in[2:0];              // Only assign needed bits
    assign out_different = in ^ left_neighbor;             // Full XOR for wrap-around

endmodule