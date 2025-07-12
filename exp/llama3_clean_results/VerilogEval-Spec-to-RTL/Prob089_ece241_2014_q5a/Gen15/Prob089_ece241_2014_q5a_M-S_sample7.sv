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
    end else if (!detector && x) begin
        detector <= 1;
        z <= x;
    end else if (detector) begin
        z <= ~x;
    end else begin
        z <= x;
    end
end

endmodule