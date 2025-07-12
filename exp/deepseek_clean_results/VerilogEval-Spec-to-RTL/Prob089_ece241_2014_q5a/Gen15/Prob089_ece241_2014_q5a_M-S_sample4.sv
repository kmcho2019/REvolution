module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg invert; // 0 = pass through, 1 = invert bits
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert <= 1'b0;
        end else if (!invert) begin
            invert <= x; // Start inverting after first '1'
        end
    end

    assign z = invert ? ~x : x;

endmodule