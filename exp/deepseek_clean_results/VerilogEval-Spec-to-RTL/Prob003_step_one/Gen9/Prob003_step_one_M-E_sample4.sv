module TopModule (
    output one
);
    // Create a ring oscillator with forced initialization
    wire node1, node2;
    
    // Initialize one node to break oscillation
    initial begin
        force node1 = 1'b1;
    end
    
    // Ring oscillator (3 inverters)
    not inv1(node2, node1);
    not inv2(one, node2);
    not inv3(node1, one);  // This completes the loop
    
    // After some time, release the force to show stability
    initial #10 release node1;
endmodule