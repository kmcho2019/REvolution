module Inverter (
    input  wire in,
    output wire out
);
    // Minimal combinational inversion with continuous assignment
    assign out = ~in;
endmodule

module TopModule (
    input  wire in,
    output wire out
);
    // Generate block to instantiate the inverter, supporting easy scalability
    generate
        genvar i;
        for (i = 0; i < 1; i = i + 1) begin : inverter_gen
            Inverter u_inv (
                .in(in),
                .out(out)
            );
        end
    endgenerate
endmodule