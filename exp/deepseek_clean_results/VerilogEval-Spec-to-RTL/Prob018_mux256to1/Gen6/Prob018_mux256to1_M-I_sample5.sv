module TopModule (
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output reg          out
);

wire [15:0] stage1_out;

genvar i;
generate
    for (i=0; i<16; i=i+1) begin : stage1_muxes
        always @(*) begin
            stage1_out[i] = in[(i*16) + sel[3:0]];
        end
    end
endgenerate

always @(*) begin
    out = stage1_out[sel[7:4]];
end

endmodule