module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg seen_one;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            seen_one <= 1'b0;
        end
        else begin
            z <= seen_one ? ~x : x;
            seen_one <= seen_one | x;
        end
    end

endmodule