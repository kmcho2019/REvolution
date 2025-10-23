module TopModule #(
    parameter WIDTH = 32
) (
    input  wire [WIDTH-1:0] in,  
    output wire [WIDTH-1:0] out  
);

    // Reverse byte order using a simple assign statement
    assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};

endmodule