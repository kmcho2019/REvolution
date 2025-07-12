module TopModule(
    input d,
    input ena,
    output reg q
);
    always @(d or ena) begin
        if (ena)
            q = d;
        else
            q = q;  // hold previous value explicitly
    end
endmodule