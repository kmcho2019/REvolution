module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg detector;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        detector <= 1'b0;
        z <= 1'b0;
    end else begin
        if (x & ~detector) begin
            detector <= 1'b1;
            z <= 1'b1;
        end else if (detector) begin
            z <= ~x;
        end else begin
            z <= 1'b0;
        end
    end
end

endmodule