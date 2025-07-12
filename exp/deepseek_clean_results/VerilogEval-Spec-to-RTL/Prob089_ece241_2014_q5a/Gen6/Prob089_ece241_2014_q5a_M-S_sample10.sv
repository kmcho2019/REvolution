module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state; // 0 = copy, 1 = invert
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 0;
        end else if (!state && x) begin
            state <= 1;
        end
    end
    
    assign z = state ? ~x : x;

endmodule