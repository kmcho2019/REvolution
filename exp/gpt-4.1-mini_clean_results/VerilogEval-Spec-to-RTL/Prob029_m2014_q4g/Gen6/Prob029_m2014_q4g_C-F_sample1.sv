module TopModule (
    input  in1,
    input  in2,
    input  in3,
    output out
);
    // Function to perform XNOR of two bits
    function automatic xnor2;
        input a, b;
        begin
            xnor2 = ~(a ^ b);
        end
    endfunction

    // Function to perform XOR of two bits
    function automatic xor2;
        input a, b;
        begin
            xor2 = a ^ b;
        end
    endfunction

    assign out = xor2(xnor2(in1, in2), in3);

endmodule