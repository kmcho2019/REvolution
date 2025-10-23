module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] count; // assuming 32-bit counter

always @(posedge clk or posedge areset) begin
    if (areset) begin
        count <= 32'b0;
        z <= 1'b0;
    end else begin
        if (x) begin
            count <= count + 1;
        end
        if (count == 32'b0) begin
            z <= ~x;
        end else begin
            z <= x;
        end
    end
end

endmodule