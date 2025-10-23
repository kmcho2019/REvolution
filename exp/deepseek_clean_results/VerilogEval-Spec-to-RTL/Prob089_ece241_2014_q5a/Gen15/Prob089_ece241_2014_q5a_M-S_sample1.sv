module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg invert_flag;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert_flag <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!invert_flag) begin
                z <= x;
                if (x) invert_flag <= 1'b1;
            end else begin
                z <= ~x;
            end
        end
    end

endmodule