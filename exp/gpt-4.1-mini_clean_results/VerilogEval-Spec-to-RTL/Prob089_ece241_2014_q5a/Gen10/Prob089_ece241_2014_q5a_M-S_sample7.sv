module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

    reg first_one_seen;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            first_one_seen <= 1'b0;
            z <= 1'b0;
        end else begin
            if (!first_one_seen) begin
                if (x) begin
                    first_one_seen <= 1'b1;
                    z <= 1'b1;
                end else begin
                    z <= 1'b0;
                end
            end else begin
                z <= ~x;
            end
        end
    end

endmodule