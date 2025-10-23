module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] count;
reg start_conv;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        count <= 0;
        start_conv <= 0;
        z <= 0;
    end else if (!start_conv && x) begin
        start_conv <= 1;
        z <= ~x;
        count <= 1;
    end else if (start_conv) begin
        if (x) begin
            z <= ~x;
        end else begin
            z <= ~x;
        end
        count <= count + 1;
    end else begin
        z <= x;
    end
end

endmodule