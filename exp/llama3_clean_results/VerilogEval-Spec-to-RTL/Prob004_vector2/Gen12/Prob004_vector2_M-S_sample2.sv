module TopModule (
    input  logic [31:0] in,  
    output logic [31:0] out  
);

    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule