module TopModule(
    input d,
    input ena,
    output reg q
);
    always @(d or ena) begin
        if (ena)
            q = d;
        // else case omitted to infer latch (q holds its value)
    end
endmodule