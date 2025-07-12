module TopModule (
    input        sel,
    input  [7:0] a,
    input  [7:0] b,
    output reg [7:0] out
);

    // Procedural 8-bit 2-to-1 mux: assign all bits of out based on sel
    always @(*) begin
        if (sel == 1'b0)
            out = a;
        else
            out = b;
    end

endmodule