module TopModule (
    input  [255:0] in,
    input  [7:0]   sel,
    output reg     out
);

    // Single-stage selection with registered output
    always @(*) begin
        out = in[sel];
    end

endmodule