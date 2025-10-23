module TopModule(
    input d,
    input ena,
    output reg q
);
    always @(ena, d) begin
        if (ena)
            q = d;
    end
endmodule