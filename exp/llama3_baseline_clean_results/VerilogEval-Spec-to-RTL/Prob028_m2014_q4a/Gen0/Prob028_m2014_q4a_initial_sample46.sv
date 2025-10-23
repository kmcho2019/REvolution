module TopModule(d, ena, q);
    input d;
    input ena;
    output q;
    reg q;

    always @(*)
    begin
        if (ena)
            q = d;
        else
            q = q;
    end
endmodule