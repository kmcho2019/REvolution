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
    end else begin
        if (x & ~detector) begin
            detector <= 1;
        end
    end
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        z <= 0;
    end else begin
        if (detector) begin
            z <= ~x;
        end else if (x) begin
            z <= 1;
        end
    end
end

endmodule