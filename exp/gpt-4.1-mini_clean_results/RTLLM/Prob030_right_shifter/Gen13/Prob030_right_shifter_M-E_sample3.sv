module right_shifter (
    input  wire       clk,
    input  wire       rst, // Active-high asynchronous reset
    input  wire       d,
    output reg  [7:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 8'b0;
    end else begin
        q <= {d, q[7:1]};
    end
end

endmodule