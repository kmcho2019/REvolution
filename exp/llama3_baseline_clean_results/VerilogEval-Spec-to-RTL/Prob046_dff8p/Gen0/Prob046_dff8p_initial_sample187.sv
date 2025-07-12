module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

parameter RESET_VALUE = 8'h34;

reg [7:0] q;

always @(posedge reset or negedge clk) begin
    if(reset) begin
        q <= RESET_VALUE;
    end else begin
        q <= d;
    end
end

assign {q[7], q[6], q[5], q[4], q[3], q[2], q[1], q[0]} = q;

endmodule