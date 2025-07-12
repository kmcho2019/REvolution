module TopModule(
    input c,
    input d,
    output [3:0] mux_in
);

    // Intermediate wires for mux outputs
    wire mux_in_0, mux_in_2, mux_in_3;
    
    // Implement mux_in[0] = d | c using a 2-to-1 mux
    assign mux_in_0 = c ? 1'b1 : d;
    
    // Implement mux_in[2] = ~d | c using a 2-to-1 mux
    assign mux_in_2 = c ? 1'b1 : ~d;
    
    // Implement mux_in[3] = c & d using a 2-to-1 mux
    assign mux_in_3 = c ? d : 1'b0;
    
    // Assign outputs in correct order
    assign mux_in = {
        mux_in_3,    // mux_in[3] (ab=11)
        mux_in_2,    // mux_in[2] (ab=10)
        1'b0,        // mux_in[1] (ab=01) - always 0
        mux_in_0     // mux_in[0] (ab=00)
    };

endmodule