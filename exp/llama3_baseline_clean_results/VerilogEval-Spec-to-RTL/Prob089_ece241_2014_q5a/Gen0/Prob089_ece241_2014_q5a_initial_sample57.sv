module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg [31:0] count;  // counter to keep track of number of bits seen
reg [31:0] result;  // register to store accumulated input bits
reg first_one;  // flag to indicate if first '1' has been seen
reg carry;  // carry bit for 2's complement computation

always @(posedge clk or posedge areset) begin
    if (areset) begin
        count <= 0;
        result <= 0;
        first_one <= 0;
        carry <= 0;
    end else begin
        if (~first_one) begin
            result <= {result[30:0], x};
            if (x == 1) begin
                first_one <= 1;
            end
        end else begin
            z <= ~(x ^ carry);
            carry <= ~(x ^ carry);
        end
    end
end

assign z = (count == 0 && ~first_one) ? 0 : z;

endmodule