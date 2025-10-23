module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [31:0] inverted_num = 0;
reg carry = 0;
reg first_bit_received = 0;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        inverted_num <= 0;
        carry <= 0;
        first_bit_received <= 0;
        z <= 0;
    end else begin
        if (!first_bit_received) begin
            inverted_num <= {31'b0, ~x};
            first_bit_received <= 1;
            if (~x) begin
                carry <= 1;
            end
        end else begin
            inverted_num <= {inverted_num[30:0], ~x};
            if (carry) begin
                if (~x) begin
                    carry <= 1;
                end else begin
                    carry <= 0;
                end
            end
        end
        z <= inverted_num[31];
    end
end

always @(posedge areset) begin
    if (areset) begin
        // add 1 to the inverted number
        inverted_num <= inverted_num + 1;
    end
end

endmodule