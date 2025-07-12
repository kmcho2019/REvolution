module TopModule (
    input  clk,
    input  areset,
    input  x,
    output reg z
);

    reg first_one_seen;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            first_one_seen <= 1'b0;
            z <= 1'b0;
        end else begin
            z <= first_one_seen ? ~x : x;
            if (~first_one_seen && x)
                first_one_seen <= 1'b1;
        end
    end

endmodule