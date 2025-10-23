module TopModule(a, b, out);
    input a;
    input b;
    output out;

    always @(*)
    begin
        if (a == 1 && b == 1)
            out = 1;
        else
            out = 0;
    end

endmodule