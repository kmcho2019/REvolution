module TopModule(
    input  in1,
    input  in2,
    output out
);
    always @(*)
    begin
        if (!(in1 || in2)) // If neither in1 nor in2 is 1
            out = 1;      // Set out to 1
        else
            out = 0;      // Otherwise, set out to 0
    end
endmodule