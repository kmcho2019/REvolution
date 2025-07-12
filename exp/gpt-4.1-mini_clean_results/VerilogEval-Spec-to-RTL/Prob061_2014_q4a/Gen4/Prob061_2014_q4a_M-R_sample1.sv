module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);
    reg d;

    always @(*) begin
        if (L)
            d = R;
        else if (E)
            d = w;
        else
            d = Q;
    end

    always @(posedge clk) begin
        Q <= d;
    end
endmodule