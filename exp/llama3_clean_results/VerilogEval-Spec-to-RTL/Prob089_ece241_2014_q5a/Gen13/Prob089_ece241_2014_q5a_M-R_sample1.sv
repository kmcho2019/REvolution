module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg detector;

assign z = (detector)? ~x : x;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        detector <= 0;
    end else begin
        if (!detector && x) begin
            detector <= 1;
        end
    end
end

endmodule