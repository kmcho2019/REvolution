module TopModule (
    input in,
    output out
);
    // Implement as a permanently enabled transmission gate
    tranif1 tg(out, in, 1'b1);  // 1'b1 keeps the gate permanently enabled
endmodule