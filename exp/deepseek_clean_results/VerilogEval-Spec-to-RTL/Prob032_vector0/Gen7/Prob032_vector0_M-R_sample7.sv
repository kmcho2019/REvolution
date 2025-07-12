module TopModule (
    input [2:0] vec,
    output [2:0] outv,
    output o2, o1, o0
);

    // Assign the entire vector directly
    assign outv = vec;
    
    // Split into individual bits using direct wiring
    assign o2 = vec[2];
    assign o1 = vec[1];
    assign o0 = vec[0];

endmodule