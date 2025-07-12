// Define a module for a transparent latch
module transparent_latch(
    input clk,  // Clock signal
    input d,    // Data input
    output q    // Output data
);

    // Use a combination of logic gates to create the transparent latch
    assign q = (clk) ? d : 1'bz;

endmodule

// Define a module for a master-slave D latch
module master_slave_latch(
    input clk,  // Clock signal
    input d,    // Data input
    output q    // Output data
);

    // Use two transparent latches in series to create the master-slave latch
    wire mid_q;
    transparent_latch master(clk, d, mid_q);
    transparent_latch slave(~clk, mid_q, q);

endmodule

// Define the TopModule with input and output ports
module TopModule(
    input clk,  // Clock signal
    input d,    // Data input
    output q    // Output data
);

    // Use the master-slave latch to create the D flip-flop
    master_slave_latch dff(clk, d, q);

endmodule