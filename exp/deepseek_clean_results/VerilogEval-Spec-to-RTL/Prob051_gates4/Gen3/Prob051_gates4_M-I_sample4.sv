module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    (* dont_touch = "true" *)
    wire out_and = &in;  // 4-input AND
    
    (* dont_touch = "true" *)
    wire out_or = |in;   // 4-input OR
    
    // Balanced XOR tree with synthesis attributes
    (* parallel_case *)
    wire xor_stage1 = in[0] ^ in[1];
    (* parallel_case *)
    wire xor_stage2 = in[2] ^ in[3];
    (* dont_touch = "true" *)
    wire out_xor = xor_stage1 ^ xor_stage2;

endmodule