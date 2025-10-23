module TopModule (
    input [2:0] in,
    output [1:0] out
);
    // Optimal implementation using direct addition
    // (synthesis tools will optimize this to efficient logic)
    assign out = in[0] + in[1] + in[2];
    
    // Alternative optimized implementation (equivalent):
    // assign out[0] = ^in;  // XOR reduction for LSB
    // assign out[1] = (in[0] & in[1]) | (in[2] & (in[0] | in[1]));  // Majority for MSB
endmodule