module TopModule(
    input d,
    input ena,
    output reg q
);
    always @(*) begin
        if (ena)
            q = d;  // transparent when ena is high
        else
            q = q;  // latch holds previous value when ena is low
    end
endmodule