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
        if (~detector) begin
            z <= x;
            detector <= x;
        end else begin
            z <= ~x;
        end
    end
end

endmodule