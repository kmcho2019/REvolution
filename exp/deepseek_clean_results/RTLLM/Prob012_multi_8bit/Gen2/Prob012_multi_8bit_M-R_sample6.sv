module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Final product calculation using nested additions
    assign product = 
        ({ {8{1'b0}}, A } & {16{B[0]}}) +  // Bit 0
        ({ {7{1'b0}}, A, 1'b0 } & {16{B[1]}}) +  // Bit 1
        ({ {6{1'b0}}, A, 2'b0 } & {16{B[2]}}) +  // Bit 2
        ({ {5{1'b0}}, A, 3'b0 } & {16{B[3]}}) +  // Bit 3
        ({ {4{1'b0}}, A, 4'b0 } & {16{B[4]}}) +  // Bit 4
        ({ {3{1'b0}}, A, 5'b0 } & {16{B[5]}}) +  // Bit 5
        ({ {2{1'b0}}, A, 6'b0 } & {16{B[6]}}) +  // Bit 6
        ({ {1{1'b0}}, A, 7'b0 } & {16{B[7]}});   // Bit 7

endmodule