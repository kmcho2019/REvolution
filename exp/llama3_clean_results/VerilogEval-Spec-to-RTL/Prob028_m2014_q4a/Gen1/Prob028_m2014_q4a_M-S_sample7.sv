module TopModule(d, ena, q);
    input d;
    input ena;
    output q;
    reg q;

    always @(d or ena)
    begin
        if (ena) q = d;
    end
endmodule