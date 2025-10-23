module TopModule(
    input  d,
    input  ena,
    output reg q
);
    reg stored_d;

    always @(ena) begin
        if (ena)
            stored_d <= d;
    end

    always @(*) begin
        if (ena)
            q = stored_d;
        else
            q = q;
    end
endmodule