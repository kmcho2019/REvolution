module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= q[0] ? {q[3:0], 1'b0} ^ 5'b00100 : {q[3:0], 1'b0};
    end
end

endmodule