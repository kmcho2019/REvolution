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
        if (!detector) begin
            detector <= x;
        end
    end
end

assign z = (detector) ? ~x : x;

endmodule