// Define a WireModule for modularity and reusability
module WireModule(
    input  wire_in,
    output wire_out
);
    
    // Direct assignment for efficiency and simplicity
    assign wire_out = wire_in;

endmodule

// Define the TopModule with the required interface
module TopModule(
    input  in,
    output out
);
    
    // Instantiate the WireModule to maintain modularity
    WireModule wire_instance(
        .wire_in(in),
        .wire_out(out)
    );

endmodule