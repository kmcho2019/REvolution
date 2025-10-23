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
    end else if (x && !detector) begin
        detector <= 1'b1;
    end
end

assign z = (detector) ? ~x : x;

endmodule