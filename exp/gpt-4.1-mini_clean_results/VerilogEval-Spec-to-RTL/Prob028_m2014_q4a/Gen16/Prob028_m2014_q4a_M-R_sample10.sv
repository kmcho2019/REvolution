module TopModule(
    input d,
    input ena,
    output reg q
);
    always @ (ena or d) begin
        if (ena)
            q = d;
        // else retain q (no assignment needed, q holds previous value)
    end
endmodule