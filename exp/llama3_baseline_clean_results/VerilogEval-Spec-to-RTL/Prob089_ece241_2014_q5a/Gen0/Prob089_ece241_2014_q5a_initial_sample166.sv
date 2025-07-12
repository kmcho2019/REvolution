module TopModule(
    input  clk,
    input  areset,
    input  x,
    output reg z
);

reg [31:0] sum;  // accumulated sum
reg flag;        // flag to track if we have started accumulating bits
reg prev_x;      // previous input bit

always @(posedge clk or posedge areset) begin
    if (areset) begin
        z <= 0;
        sum <= 0;
        flag <= 0;
        prev_x <= 0;
    end else begin
        if (~flag) begin  // if we haven't started accumulating bits yet
            if (x == 1) begin  // if the current bit is 1, start accumulating
                flag <= 1;
                sum <= 1;
                prev_x <= x;
            end else begin
                prev_x <= x;
            end
        end else begin  // if we have started accumulating bits
            if (~x) begin  // if the current bit is 0, just shift the sum
                sum <= {sum[30:0], 1'b0};
            end else begin  // if the current bit is 1, invert and add 1
                sum <= {sum[30:0], 1'b1};
            end
            prev_x <= x;
        end
        if (prev_x == 1 && x == 0) begin  // if this is the last bit
            z <= sum[0];
        end else begin
            z <= sum[0] ^ 1;  // output the inverted bit
        end
    end
end
endmodule