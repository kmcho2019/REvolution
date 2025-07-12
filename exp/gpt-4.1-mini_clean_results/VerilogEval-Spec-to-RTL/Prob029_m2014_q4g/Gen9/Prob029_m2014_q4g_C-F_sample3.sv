module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);

    // Local function for 2-input XNOR gate
    function xnor2;
        input a, b;
        begin
            xnor2 = ~(a ^ b);
        end
    endfunction

    // Local function for 2-input XOR gate
    function xor2;
        input a, b;
        begin
            xor2 = a ^ b;
        end
    endfunction

    assign out = xor2(xnor2(in1, in2), in3);

endmodule