module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Vectorized AND computation
    wire [5:0] p1_vector = {p1a, p1b, p1c, p1d, p1e, p1f};
    wire [3:0] p2_vector = {p2a, p2b, p2c, p2d};
    
    // Parallel AND computation using bitwise operations
    wire and3_1 = &p1_vector[5:3];  // p1a & p1b & p1c
    wire and3_2 = &p1_vector[2:0];  // p1d & p1e & p1f
    wire and2_1 = &p2_vector[3:2];  // p2a & p2b
    wire and2_2 = &p2_vector[1:0];  // p2c & p2d
    
    // Output combination
    assign p1y = and3_1 | and3_2;
    assign p2y = and2_1 | and2_2;
endmodule