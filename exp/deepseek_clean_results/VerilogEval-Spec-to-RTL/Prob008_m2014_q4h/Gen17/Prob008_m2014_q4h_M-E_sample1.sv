module TopModule (
    input in,
    output out
);
    // Implement as a 2:1 mux where we always select the input
    // sel=1: choose in
    // sel=0: choose 0 (but we'll tie sel to 1)
    assign out = in ? 1'b1 : 1'b0;
endmodule