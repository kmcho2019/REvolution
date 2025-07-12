module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [31:0] inverted_num = 0;
reg carry = 1;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        inverted_num <= 0;
        carry <= 1;
        z <= 0;
    end else begin
        inverted_num <= {inverted_num[30:0], ~x};
        if (carry && ~x) begin
            carry <= 0;
        end else if (~carry && x) begin
            carry <= 1;
        end
        z <= inverted_num[31] ^ carry;
    end
end

endmodule