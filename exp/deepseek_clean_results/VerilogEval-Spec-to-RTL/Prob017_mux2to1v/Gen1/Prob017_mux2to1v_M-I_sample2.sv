module TopModule (
    input  [99:0] a,
    input  [99:0] b,
    input         sel,
    input         en,    // New enable signal
    output [99:0] out
);

    // Power-optimized version with enable
    assign out = en ? (sel ? b : a) : 100'b0;

    // Alternative sequential version (commented out)
    // reg [99:0] out_reg;
    // always @(*) begin
    //     if (en) begin
    //         out_reg = sel ? b : a;
    //     end
    // end
    // assign out = out_reg;
endmodule