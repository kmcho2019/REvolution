module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg   out
);

    // Combinational block implementing 1-bit 2-to-1 mux selecting bit 0
    always @(*) begin
        if (sel)
            out = b[0];
        else
            out = a[0];
    end

endmodule