module TopModule (
    input a,
    input b,
    input c,
    input d,
    input e,
    output [24:0] out
);

    // Organized input vector for clearer indexing
    wire [4:0] inputs = {a, b, c, d, e};
    
    // Direct equality comparisons with simplified indexing
    assign out[24] = (inputs[4] == inputs[4]);
    assign out[23] = (inputs[4] == inputs[3]);
    assign out[22] = (inputs[4] == inputs[2]);
    assign out[21] = (inputs[4] == inputs[1]);
    assign out[20] = (inputs[4] == inputs[0]);
    
    assign out[19] = (inputs[3] == inputs[4]);
    assign out[18] = (inputs[3] == inputs[3]);
    assign out[17] = (inputs[3] == inputs[2]);
    assign out[16] = (inputs[3] == inputs[1]);
    assign out[15] = (inputs[3] == inputs[0]);
    
    assign out[14] = (inputs[2] == inputs[4]);
    assign out[13] = (inputs[2] == inputs[3]);
    assign out[12] = (inputs[2] == inputs[2]);
    assign out[11] = (inputs[2] == inputs[1]);
    assign out[10] = (inputs[2] == inputs[0]);
    
    assign out[9]  = (inputs[1] == inputs[4]);
    assign out[8]  = (inputs[1] == inputs[3]);
    assign out[7]  = (inputs[1] == inputs[2]);
    assign out[6]  = (inputs[1] == inputs[1]);
    assign out[5]  = (inputs[1] == inputs[0]);
    
    assign out[4]  = (inputs[0] == inputs[4]);
    assign out[3]  = (inputs[0] == inputs[3]);
    assign out[2]  = (inputs[0] == inputs[2]);
    assign out[1]  = (inputs[0] == inputs[1]);
    assign out[0]  = (inputs[0] == inputs[0]);

endmodule