module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg sign;
reg [7:0] sum;
reg carry;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        sign <= 0;
        sum <= 0;
        carry <= 0;
    end else begin
        if (~sign) begin
            sign <= 1;
            sum <= ~x;
            carry <= ~x;
        end else begin
            sum <= sum + ~x + carry;
            carry <= (sum[7] && ~x) || (sum[7] && carry) || (~x && carry);
            sum <= sum[7:0];
        end
    end
end

assign z = sum[0];

endmodule