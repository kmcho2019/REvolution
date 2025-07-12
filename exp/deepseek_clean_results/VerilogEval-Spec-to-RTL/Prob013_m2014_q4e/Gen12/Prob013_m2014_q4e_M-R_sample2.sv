module TopModule (
    input in1,
    input in2,
    output out
);
    function nor_gate;
        input a;
        input b;
        begin
            nor_gate = ~(a | b);
        end
    endfunction

    assign out = nor_gate(in1, in2);
endmodule