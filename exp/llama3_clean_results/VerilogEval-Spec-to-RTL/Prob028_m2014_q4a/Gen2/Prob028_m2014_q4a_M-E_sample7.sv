module TopModule(d, ena, q);
    input d;
    input ena;
    output q;
    reg q;
    reg internal_d;

    always @(ena or d)
    begin
        if (ena) begin
            internal_d = d;
        end
    end

    always @(internal_d)
    begin
        q = internal_d;
    end
endmodule