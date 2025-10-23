module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output       z
);
    wire [1:0] diff;
    wire       borrow;

    // 2-bit subtractor: diff = A - B
    assign {borrow, diff} = {1'b0, A} - {1'b0, B};

    // z = 1 if diff == 0, else 0
    assign z = ~(diff[1] | diff[0]);
endmodule