module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First reduction stage: 100 -> 64
    wire [63:0] stage1_and, stage1_or, stage1_xor;
    
    // AND reduction
    assign stage1_and[63:36] = {&in[99:96], &in[95:92], &in[91:88], &in[87:84],
                               &in[83:80], &in[79:76], &in[75:72], &in[71:68],
                               &in[67:64], &in[63:60], &in[59:56], &in[55:52],
                               &in[51:48], &in[47:44], &in[43:40], &in[39:36]};
    assign stage1_and[35:0] = {&in[35:32], &in[31:28], &in[27:24], &in[23:20],
                              &in[19:16], &in[15:12], &in[11:8], &in[7:4],
                              &in[3:0], 28'b1}; // Pad with 1's for AND
    
    // OR reduction
    assign stage1_or[63:36] = {|in[99:96], |in[95:92], |in[91:88], |in[87:84],
                              |in[83:80], |in[79:76], |in[75:72], |in[71:68],
                              |in[67:64], |in[63:60], |in[59:56], |in[55:52],
                              |in[51:48], |in[47:44], |in[43:40], |in[39:36]};
    assign stage1_or[35:0] = {|in[35:32], |in[31:28], |in[27:24], |in[23:20],
                             |in[19:16], |in[15:12], |in[11:8], |in[7:4],
                             |in[3:0], 28'b0}; // Pad with 0's for OR
    
    // XOR reduction
    assign stage1_xor[63:36] = {^in[99:96], ^in[95:92], ^in[91:88], ^in[87:84],
                               ^in[83:80], ^in[79:76], ^in[75:72], ^in[71:68],
                               ^in[67:64], ^in[63:60], ^in[59:56], ^in[55:52],
                               ^in[51:48], ^in[47:44], ^in[43:40], ^in[39:36]};
    assign stage1_xor[35:0] = {^in[35:32], ^in[31:28], ^in[27:24], ^in[23:20],
                              ^in[19:16], ^in[15:12], ^in[11:8], ^in[7:4],
                              ^in[3:0], 28'b0}; // Pad with 0's for XOR

    // Binary tree reduction for 64 inputs
    assign out_and = &stage1_and;
    assign out_or = |stage1_or;
    assign out_xor = ^stage1_xor;

endmodule