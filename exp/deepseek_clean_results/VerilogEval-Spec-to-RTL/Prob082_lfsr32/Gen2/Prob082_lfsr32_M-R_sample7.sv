module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

wire feedback;
assign feedback = q[0];

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end
    else begin
        q <= {1'b0, q[31:1]} ^ 
             ({32{feedback}} & (32'h80000000 | 32'h00200000 | 32'h00000002 | 32'h00000001));
    end
end

endmodule