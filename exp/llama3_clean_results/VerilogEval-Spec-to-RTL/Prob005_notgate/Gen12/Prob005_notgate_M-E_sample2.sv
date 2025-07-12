module TopModule(
    input  in,
    output out
);
    wire inv_in;
    assign inv_in = ~in;
    
    multiplexer mux_instance(
        .sel(1'b1),  // Control signal to select the inverse
        .a(in),      // Input
        .b(inv_in),  // Inverse of input
        .out(out)    // Output of the MUX, which is the NOT gate's output
    );
    
    // Define the multiplexer module
    module multiplexer(
        input  sel,
        input  a,
        input  b,
        output out
    );
        assign out = sel ? b : a;
    endmodule
endmodule