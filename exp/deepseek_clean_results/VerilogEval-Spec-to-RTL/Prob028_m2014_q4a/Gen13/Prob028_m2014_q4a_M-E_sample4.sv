module TopModule(d, ena, q);
    input d, ena;
    output reg q;

    always @(d or ena) begin
        if (ena) begin
            q = d;
        end
    end
endmodule