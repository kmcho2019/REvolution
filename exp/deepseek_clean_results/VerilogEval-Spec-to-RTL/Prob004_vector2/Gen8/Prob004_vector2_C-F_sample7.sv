module TopModule #(parameter WIDTH = 32) (
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out
);
    localparam BYTES = WIDTH/8;
    
    // Direct concatenation with parameterized width
    generate
        if (BYTES == 4) begin
            assign out = {in[7:0], in[15:8], in[23:16], in[31:24]};
        end
        // Additional cases could be added for other widths
    endgenerate
endmodule