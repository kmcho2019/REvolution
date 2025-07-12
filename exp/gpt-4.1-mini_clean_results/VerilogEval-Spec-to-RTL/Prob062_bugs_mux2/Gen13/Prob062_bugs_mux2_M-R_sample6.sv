module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg   out
);

    // Procedural 2-to-1 mux selecting LSB of a or b
    always @(*) begin
        if (sel)
            out = b[0];
        else
            out = a[0];
    end

endmodule