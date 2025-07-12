module TopModule(
    input d,
    input ena,
    output reg q
);
    always @(*) begin
        if (ena)
            q = d;
        // else retain previous value of q (no assignment)
    end
endmodule