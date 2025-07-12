module TopModule (
    input  [1023:0] in,
    input  [7:0]    sel,
    output [3:0]    out
);

    wire [3:0] intermediate [15:0];
    
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : first_level
            assign intermediate[i] = in[(i*64 + sel[3:0]*4) +: 4];
        end
    endgenerate
    
    assign out = intermediate[sel[7:4]];
    
endmodule