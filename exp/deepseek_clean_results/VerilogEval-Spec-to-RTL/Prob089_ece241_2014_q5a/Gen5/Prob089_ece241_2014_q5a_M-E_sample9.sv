module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg toggle;
    reg seen_one;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            toggle <= 1'b0;
            seen_one <= 1'b0;
        end
        else begin
            if (!seen_one && x) begin
                seen_one <= 1'b1;
                toggle <= 1'b1;
            end
            else if (seen_one) begin
                toggle <= 1'b1;
            end
        end
    end
    
    assign z = x ^ toggle;

endmodule