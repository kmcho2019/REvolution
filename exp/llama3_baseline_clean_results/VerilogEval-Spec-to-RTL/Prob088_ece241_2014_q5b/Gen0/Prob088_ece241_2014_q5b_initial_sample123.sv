module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg a_A, a_B;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        a_A <= 1'b1;
        a_B <= 1'b0;
    end else begin
        if (a_A && !x) begin
            a_A <= 1'b1;
            a_B <= 1'b0;
        end else if (a_A && x) begin
            a_A <= 1'b0;
            a_B <= 1'b1;
        end else if (a_B) begin
            // Regardless of x, stay in state B
            a_A <= 1'b0;
            a_B <= 1'b1;
        end
    end
end

always @(*) begin
    if (a_A && !x) begin
        z = 1'b0;
    end else if (a_A && x) begin
        z = 1'b1;
    end else if (a_B) begin
        if (!x) begin
            z = 1'b1;
        end else begin
            z = 1'b0;
        end
    end
end

endmodule