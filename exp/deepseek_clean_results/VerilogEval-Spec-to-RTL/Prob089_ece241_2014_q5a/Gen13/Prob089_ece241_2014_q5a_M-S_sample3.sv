module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg invert_flag;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert_flag <= 0;
            z <= 0;
        end else begin
            z <= invert_flag ? ~x : x;
            if (!invert_flag && x) begin
                invert_flag <= 1;
            end
        end
    end

endmodule