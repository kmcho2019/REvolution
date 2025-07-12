module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg detected;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        detected <= 0;
    end else if (!detected && x) begin
        detected <= 1;
    end
end

always @(posedge clk) begin
    if (detected) begin
        z <= ~x;
    end else begin
        z <= x;
    end
end

endmodule