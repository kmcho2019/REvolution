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
    end else if (!detector) begin
        z <= x;
        detector <= x; // Simplified logic for detector update
    end else begin
        z <= ~x; // Maintaining the 2's complement operation
    end
end

endmodule