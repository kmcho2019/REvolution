module TopModule(
    input  d,
    input  ena,
    output reg q
);

    always @* begin
        if (ena)
            q = d;    // latch transparent when ena=1
        else
            q = q;    // latch holds value when ena=0
    end

endmodule