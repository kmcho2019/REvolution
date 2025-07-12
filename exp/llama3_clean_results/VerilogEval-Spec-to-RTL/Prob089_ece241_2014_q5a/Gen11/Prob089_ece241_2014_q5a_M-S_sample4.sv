module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg first_one_seen;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        first_one_seen <= 0;
        z <= 0;
    end else begin
        if (~first_one_seen) begin
            z <= x; // Before first '1', output is input
            if (x) begin
                first_one_seen <= 1;
            end
        end else begin
            // Invert input bit and add 1 if input is 1
            z <= ~x;
            if (x) begin
                z <= ~z + 1; // Add 1 if input is 1
            end
        end
    end
end

endmodule