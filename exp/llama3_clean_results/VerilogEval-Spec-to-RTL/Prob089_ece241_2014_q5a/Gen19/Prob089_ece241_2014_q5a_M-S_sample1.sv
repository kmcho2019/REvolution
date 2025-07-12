module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg detector;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        detector <= 0;
    end else if (!detector) begin
        z <= x;
        detector <= x;
    end else begin
        z <= ~x;
    end
end

endmodule