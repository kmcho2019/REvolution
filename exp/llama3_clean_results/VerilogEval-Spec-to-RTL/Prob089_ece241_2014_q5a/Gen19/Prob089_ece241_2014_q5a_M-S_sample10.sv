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
    end else if (!detector && x) begin
        detector <= 1;
    end
    z <= detector ? ~x : x;
end

endmodule