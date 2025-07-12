module right_shifter (
    input  wire       clk,
    input  wire       d,
    output reg  [7:0] q
);

initial q = 8'b0;

wire [7:0] next_q;
assign next_q = {d, q[7:1]};

always @(posedge clk) begin
    q <= next_q;
end

endmodule