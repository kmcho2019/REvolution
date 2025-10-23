module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

reg [7:0] sum;
reg carry;
reg sign;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        sum <= 8'd0;
        carry <= 1'b0;
        sign <= 1'b0;
    end else begin
        if (~sign) begin
            sign <= 1'b1;
            carry <= x;
            sum <= ~x;
        end else begin
            sum <= {sum[6:0], ~x};
            carry <= x;
            z <= sum[7];
        end
    end
end

endmodule