module TopModule(
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    genvar i;

    generate
        for (i = 0; i < 100; i++) begin
            if (i < 99) begin
                assign out_both[i] = in[i] & in[i+1];
            end else begin
                assign out_both[i] = 1'b0;
            end
            
            if (i > 0) begin
                assign out_any[i] = in[i] | in[i-1];
            end else begin
                assign out_any[i] = 1'b0;
            end
            
            assign out_different[i] = in[i] ^ ((i == 99) ? in[0] : in[i+1]);
        end
    endgenerate

endmodule