module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

    always @(posedge clk) begin
        if (L | E) begin
            if (L)
                Q <= R;
            else
                Q <= w;
        end
    end

endmodule