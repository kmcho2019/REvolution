module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg A;
reg B;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        A <= 1'b1;
        B <= 1'b0;
    end else begin
        if (A) begin
            if (x) begin
                A <= 1'b0;
                B <= 1'b1;
            end else begin
                A <= 1'b1;
                B <= 1'b0;
            end
        end else if (B) begin
            B <= 1'b1;
            A <= 1'b0;
        end
    end
end

always @(*) begin
    if (A) begin
        z = 1'b0;
    end else if (B) begin
        z = x ? 1'b0 : 1'b1;
    end
end

endmodule