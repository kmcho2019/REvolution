module MUX1(
    input  mux_in,
    input  [0:0] sel, // Select line tied to constant
    output mux_out
);

    // MUX implementation with a single input, for potential future expansion
    assign mux_out = mux_in;

endmodule

module TopModule(
    input  in,
    output out
);

    // Instantiate the MUX module with the select line tied to a constant (0)
    wire sel_const = 1'b0; // Tied to constant for simplicity
    MUX1 mux_instance(
        .mux_in(in),
        .sel(sel_const),
        .mux_out(out)
    );

endmodule