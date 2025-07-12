module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);

// Fusion of semantic clarity and explicit minimal gate logic:
// (A == B) ensures synthesis infers a comparator cell;
// &(~(A ^ B)) explicitly shows the XNOR + reduction AND logic;
// Combining with logical AND lets tools optimize or verify equivalence.
assign z = (A == B) & &(~(A ^ B));

endmodule