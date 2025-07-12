module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] out
);

    // Combinational mux using always block to select a or b
    always @(*) begin
        if (sel)
            out = b;
        else
            out = a;
    end

endmodule