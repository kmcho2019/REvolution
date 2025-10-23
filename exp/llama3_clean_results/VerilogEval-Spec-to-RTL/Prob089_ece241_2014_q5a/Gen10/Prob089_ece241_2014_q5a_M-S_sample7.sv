module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg start_complement;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        start_complement <= 1'b0;
        z <= 1'b0;
    end else if (!start_complement && x) begin
        start_complement <= 1'b1;
        z <= 1'b1;
    end else if (!start_complement) begin
        z <= 1'b0;
    end else begin
        z <= ~x;
    end
end

endmodule