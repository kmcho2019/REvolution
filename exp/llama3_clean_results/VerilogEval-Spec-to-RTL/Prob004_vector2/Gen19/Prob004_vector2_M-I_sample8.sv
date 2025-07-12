module TopModule (
    input  logic [31:0] in,  
    output logic [31:0] out  
);

    assign out[7:0]   = in[24:17];
    assign out[15:8]  = in[16:9];
    assign out[23:16] = in[8:1];
    assign out[31:24] = in[0:7];

endmodule