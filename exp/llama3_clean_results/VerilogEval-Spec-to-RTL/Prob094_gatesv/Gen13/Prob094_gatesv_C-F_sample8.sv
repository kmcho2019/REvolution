module TopModule #(
    parameter WIDTH = 4
)(
    input  [WIDTH-1:0] in,
    output [WIDTH-1:0] out_both,
    output [WIDTH-1:0] out_any,
    output [WIDTH-1:0] out_different
);
    genvar i;
    generate
        for (i = 0; i < WIDTH; i++) begin
            if (i == WIDTH - 1) begin
                assign out_both[i] = 1'b0;
                assign out_different[i] = in[i] ^ in[0];
            end else begin
                assign out_both[i] = in[i] & in[i+1];
                assign out_different[i] = in[i] ^ in[i+1];
            end
            
            if (i == 0) begin
                assign out_any[i] = in[i];
            end else begin
                assign out_any[i] = in[i] | in[i-1];
            end
        end
    endgenerate
endmodule