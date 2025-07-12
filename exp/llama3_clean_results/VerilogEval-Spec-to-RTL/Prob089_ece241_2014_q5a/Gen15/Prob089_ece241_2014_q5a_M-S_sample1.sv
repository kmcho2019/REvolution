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
        z <= 0;
    end else begin
        if (detector) begin
            z <= ~x;
        end else begin
            z <= x;
            if (x) detector <= 1;
        end
    end
end

endmodule