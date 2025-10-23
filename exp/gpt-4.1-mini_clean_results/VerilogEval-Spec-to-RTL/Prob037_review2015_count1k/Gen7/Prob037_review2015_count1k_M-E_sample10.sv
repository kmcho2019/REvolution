module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    wire [10:0] sum;  // 11 bits to hold q + 1 result potentially exceeding 10 bits
    wire [10:0] wrapped;

    assign sum = {1'b0, q} + 11'd1;
    assign wrapped = (sum >= 11'd1000) ? (sum - 11'd1000) : sum;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
        end else begin
            q <= wrapped[9:0];
        end
    end

endmodule