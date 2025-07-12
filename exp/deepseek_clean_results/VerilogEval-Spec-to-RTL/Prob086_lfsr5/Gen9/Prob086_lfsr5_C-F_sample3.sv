module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[2] ^ q[0];

always @(posedge clk) begin
    q <= reset ? 5'b00001 : {q[0], q[4], feedback, q[2], q[1]};
end

endmodule