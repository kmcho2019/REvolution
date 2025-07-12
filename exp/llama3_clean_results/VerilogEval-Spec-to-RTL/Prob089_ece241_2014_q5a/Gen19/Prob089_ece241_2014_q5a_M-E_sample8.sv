module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [31:0] counter;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        counter <= 0;
        z <= 0;
    end else begin
        if (x) begin
            counter <= counter + 1;
        end
        if (counter > 0) begin
            z <= ~x;
        end else begin
            z <= x;
        end
    end
end

endmodule