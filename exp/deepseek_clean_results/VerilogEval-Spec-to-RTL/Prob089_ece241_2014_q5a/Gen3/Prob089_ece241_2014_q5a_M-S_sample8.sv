module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg invert;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert <= 1'b0;
        end else if (!invert && x) begin
            invert <= 1'b1;
        end
    end

    assign z = x ^ invert;

endmodule