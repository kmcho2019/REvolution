module TopModule(
    input clk,
    input a,
    output reg [2:0] q
);

always @(posedge clk or negedge a) begin
    if (~a) begin // If a is 0, increment q
        q <= q + 1;
    end else begin // If a is 1, load 4 into q
        q <= 4;
    end
end

endmodule