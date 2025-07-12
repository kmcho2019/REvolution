module TopModule(d, ena, q);
    input d;
    input ena;
    output q;
    reg q; // Declare q as a reg type for the always block

    always @(ena or d) begin
        if (ena) begin
            q <= d;
        end
    end
endmodule