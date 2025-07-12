module ByteSplitter16 (
    input  [15:0] in,
    output reg [7:0] out_hi,
    output reg [7:0] out_lo
);
    // Use always block for combinational assignments
    always @(*) begin
        out_hi = in[15:8];
        out_lo = in[7:0];
    end
endmodule

module TopModule (
    input  [15:0] in,
    output [7:0] out_hi,
    output [7:0] out_lo
);

    // Instantiate the byte splitter with procedural assignments
    ByteSplitter16 splitter (
        .in(in),
        .out_hi(out_hi),
        .out_lo(out_lo)
    );

endmodule