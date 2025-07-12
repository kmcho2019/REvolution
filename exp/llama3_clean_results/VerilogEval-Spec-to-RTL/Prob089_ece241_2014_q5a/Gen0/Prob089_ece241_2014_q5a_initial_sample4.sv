module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [31:0] inverted_num = 0;
reg [31:0] result = 0;
reg carry = 0;
reg [4:0] bit_counter = 0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        inverted_num <= 0;
        result <= 0;
        carry <= 0;
        bit_counter <= 0;
        z <= 0;
    end else begin
        if (bit_counter == 0) begin
            inverted_num <= ~x;
            carry <= 1;
            bit_counter <= 1;
        end else begin
            inverted_num <= {inverted_num[30:0], ~x};
            if (carry) begin
                if (~x) begin
                    carry <= 0;
                end
            end
            bit_counter <= bit_counter + 1;
        end
        z <= inverted_num[31];
    end
end

endmodule