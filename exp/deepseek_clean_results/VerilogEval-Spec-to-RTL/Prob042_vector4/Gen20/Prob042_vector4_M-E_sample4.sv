module TopModule (
    input  [7:0] in,
    output [31:0] out
);
    wire [23:0] ext_positive = 24'b0;
    wire [23:0] ext_negative = 24'hFFFFFF;
    
    wire [23:0] selected_ext = in[7] ? ext_negative : ext_positive;
    
    assign out = {selected_ext, in};
endmodule