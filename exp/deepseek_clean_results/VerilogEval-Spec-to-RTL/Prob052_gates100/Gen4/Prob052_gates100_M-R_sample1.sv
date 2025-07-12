module TopModule (
    input [99:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // First stage: Process 10 groups of 10 bits each
    wire [9:0] and_stage1 = {
        &in[99:90], &in[89:80], &in[79:70], &in[69:60], &in[59:50],
        &in[49:40], &in[39:30], &in[29:20], &in[19:10], &in[9:0]
    };
    
    wire [9:0] or_stage1 = {
        |in[99:90], |in[89:80], |in[79:70], |in[69:60], |in[59:50],
        |in[49:40], |in[39:30], |in[29:20], |in[19:10], |in[9:0]
    };
    
    wire [9:0] xor_stage1 = {
        ^in[99:90], ^in[89:80], ^in[79:70], ^in[69:60], ^in[59:50],
        ^in[49:40], ^in[39:30], ^in[29:20], ^in[19:10], ^in[9:0]
    };

    // Second stage: Combine the 10 intermediate results
    assign out_and = &and_stage1;
    assign out_or  = |or_stage1;
    assign out_xor = ^xor_stage1;

endmodule