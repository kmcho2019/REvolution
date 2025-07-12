module TopModule (
    input [1:0] A,
    input [1:0] B,
    output z
);
    // Implements A == B using XNOR gates for each bit pair
    // followed by AND (synthesizes to same as: (A[1] ~^ B[1]) & (A[0] ~^ B[0]))
    assign z = (A == B);
endmodule