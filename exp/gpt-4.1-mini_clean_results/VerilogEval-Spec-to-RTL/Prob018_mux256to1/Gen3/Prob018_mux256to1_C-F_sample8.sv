module TopModule(
    input  wire [255:0] in,
    input  wire [7:0]   sel,
    output reg          out
);

    always @(*) begin
        out = in[sel];
    end

endmodule