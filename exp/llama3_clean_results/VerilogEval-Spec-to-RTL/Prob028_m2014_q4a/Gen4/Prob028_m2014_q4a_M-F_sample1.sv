module TopModule(d, ena, q);
    input d;
    input ena;
    output reg q;

    always @(d, ena) // Explicitly list both d and ena in the sensitivity list
    begin
        if (ena) begin
            q = d; // Directly update q with d when ena is high
        end
    end
endmodule