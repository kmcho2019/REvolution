module TopModule (
    output one
);
    // Implement a 1-bit ROM that always outputs 1
    localparam [0:0] ROM = 1'b1;
    
    assign one = ROM[0];
endmodule