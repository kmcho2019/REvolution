module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg seen_one;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
        end
        else begin
            seen_one <= seen_one | x;
        end
    end

    assign z = seen_one ? ~x : x;

endmodule