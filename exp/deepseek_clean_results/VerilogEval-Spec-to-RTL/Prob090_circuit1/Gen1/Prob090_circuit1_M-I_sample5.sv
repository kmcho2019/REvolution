module TopModule (
    input a,
    input b,
    output q
);
    // Explicit AND gate instantiation for better library control
    AND2X1 and_inst (.A(a), .B(b), .Y(q));
endmodule