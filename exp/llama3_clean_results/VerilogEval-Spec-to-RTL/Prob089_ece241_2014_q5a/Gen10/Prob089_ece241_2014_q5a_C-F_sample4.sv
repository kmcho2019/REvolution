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
            if (x) begin
                detector <= 1'b1;
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