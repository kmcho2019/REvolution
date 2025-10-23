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
        z <= detector? ~x : x;
        if (!detector && x) detector <= 1;
    end
end

endmodule