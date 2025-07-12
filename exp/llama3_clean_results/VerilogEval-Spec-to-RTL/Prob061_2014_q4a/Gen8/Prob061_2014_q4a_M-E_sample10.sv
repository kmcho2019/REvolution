module TopModule(
    input clk,
    input w,
    input R,
    input E,
    input L,
    output reg Q
);

reg hold;

always @(*) begin
    if (L) begin
        hold = 0;
    end else if (E) begin
        hold = 0;
    end else begin
        hold = 1;
    end
end

always @(posedge clk) begin
    if (!hold) begin
        if (L) begin
            Q <= R;
        end else if (E) begin
            Q <= w;
        end
    end
end

endmodule