module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    reg found_one;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            found_one <= 0;
            z <= 0;
        end else begin
            if (!found_one) begin
                if (x) begin
                    found_one <= 1;
                    z <= x;
                end else begin
                    z <= x;
                end
            end else begin
                z <= ~x;
            end
        end
    end

endmodule