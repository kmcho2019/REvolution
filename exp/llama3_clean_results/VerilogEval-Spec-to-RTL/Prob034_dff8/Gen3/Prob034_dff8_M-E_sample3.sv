module TopModule(
    input clk,
    input rst,
    input [7:0] d,
    output reg [7:0] q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        q <= 8'd0;
    end else begin
        q <= d;
    end
end

endmodule