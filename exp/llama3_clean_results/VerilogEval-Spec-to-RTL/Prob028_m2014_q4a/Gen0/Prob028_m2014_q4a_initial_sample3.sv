module TopModule(d, ena, q);
    input d;
    input ena;
    output q;
    reg q; // Declare q as a reg type for procedural assignment

    always @(d or ena) // Sensitivity list includes both d and ena
    begin
        if (ena) // When ena is high, latch the input d into q
            q = d;
        // When ena is low, q retains its value
    end
endmodule