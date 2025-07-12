module TopModule(d, ena, q);
    input d;
    input ena;
    output q;
    reg q; // Declare q as a reg type for procedural assignment

    always @(d, ena) // Sensitivity list includes both d and ena
        if (ena) // Check if enable signal is high
            q = d; // Assign d to q when ena is high

endmodule