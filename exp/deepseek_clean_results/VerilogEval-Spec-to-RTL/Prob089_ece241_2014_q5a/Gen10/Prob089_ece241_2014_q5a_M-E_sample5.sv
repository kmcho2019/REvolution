module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg invert_flag;
    reg seen_one;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert_flag <= 1'b0;
            seen_one <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!seen_one) begin
                seen_one <= x;
                invert_flag <= x;
                z <= x;
            end else begin
                z <= invert_flag ? ~x : x;
            end
        end
    end

endmodule