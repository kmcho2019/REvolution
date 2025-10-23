module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Single-line assignments using concatenated operations
    assign out = {(in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]), 
                  in[0] ^ in[1] ^ in[2]};

endmodule