module TopModule (
    input  wire a,
    input  wire b,
    output reg  out_and,
    output reg  out_or,
    output reg  out_xor,
    output wire out_nand,
    output wire out_nor,
    output wire out_xnor,
    output reg  out_anotb
);

    // Intermediate wires for shared signals
    wire and_ab;
    wire or_ab;
    wire xor_ab;

    // Combinational block computes all direct outputs
    always @(*) begin
        out_and   = a & b;
        out_or    = a | b;
        out_xor   = a ^ b;
        out_anotb = a & ~b;
    end

    assign and_ab = out_and;
    assign or_ab  = out_or;
    assign xor_ab = out_xor;

    // Outputs derived by inverting intermediate signals
    assign out_nand = ~and_ab;
    assign out_nor  = ~or_ab;
    assign out_xnor = ~xor_ab;

endmodule