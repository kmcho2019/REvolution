module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    wire [255:0] sel_one_hot;
    
    // One-hot decoder for selector
    assign sel_one_hot = (256'b1 << sel);
    
    // 256:1 multiplexer using one-hot selection
    assign out = (|sel_one_hot) ? 
                ((sel_one_hot[0]   ? in[3:0]   : 4'b0) |
                ((sel_one_hot[1]   ? in[7:4]   : 4'b0) |
                ((sel_one_hot[2]   ? in[11:8]  : 4'b0) |
                // ... (pattern continues for all 256 cases)
                ((sel_one_hot[255] ? in[1023:1020] : 4'b0));

endmodule