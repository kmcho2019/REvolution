module multi_8bit (
    input [7:0] A,
    input [7:0] B,
    output [15:0] product
);

    // Generate all 8 partial products
    wire [15:0] pp0 = {{8{1'b0}}, A} & {16{B[0]}};
    wire [15:0] pp1 = {{7{1'b0}}, A, 1'b0} & {16{B[1]}};
    wire [15:0] pp2 = {{6{1'b0}}, A, 2'b0} & {16{B[2]}};
    wire [15:0] pp3 = {{5{1'b0}}, A, 3'b0} & {16{B[3]}};
    wire [15:0] pp4 = {{4{1'b0}}, A, 4'b0} & {16{B[4]}};
    wire [15:0] pp5 = {{3{1'b0}}, A, 5'b0} & {16{B[5]}};
    wire [15:0] pp6 = {{2{1'b0}}, A, 6'b0} & {16{B[6]}};
    wire [15:0] pp7 = {{1{1'b0}}, A, 7'b0} & {16{B[7]}};

    // Reduction tree to sum all partial products
    wire [15:0] sum01 = pp0 + pp1;
    wire [15:0] sum23 = pp2 + pp3;
    wire [15:0] sum45 = pp4 + pp5;
    wire [15:0] sum67 = pp6 + pp7;
    
    wire [15:0] sum0123 = sum01 + sum23;
    wire [15:0] sum4567 = sum45 + sum67;
    
    assign product = sum0123 + sum4567;

endmodule