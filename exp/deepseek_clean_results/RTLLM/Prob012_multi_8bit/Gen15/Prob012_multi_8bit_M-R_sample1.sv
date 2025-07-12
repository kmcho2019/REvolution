module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate and sum all partial products in one expression
    assign product = 
        (({8'b0, A} & {16{B[0]}}) +
        ({7'b0, A, 1'b0} & {16{B[1]}}) +
        ({6'b0, A, 2'b0} & {16{B[2]}}) +
        ({5'b0, A, 3'b0} & {16{B[3]}}) +
        ({4'b0, A, 4'b0} & {16{B[4]}}) +
        ({3'b0, A, 5'b0} & {16{B[5]}}) +
        ({2'b0, A, 6'b0} & {16{B[6]}}) +
        ({1'b0, A, 7'b0} & {16{B[7]}}));

endmodule