module EdgeDetect(
    input clk,
    input in,
    output reg pedge
);

reg [1:0] sr;  // shift register to store current and previous states

always @(posedge clk) begin
    sr[0] <= in;  // update current state
    sr[1] <= sr[0];  // update previous state
    pedge <= sr[0] & ~sr[1];  // detect positive edge
end

endmodule

module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

genvar i;
generate
    for (i = 0; i < 8; i++) begin
        EdgeDetect edge_detect(
           .clk(clk),
           .in(in[i]),
           .pedge(pedge[i])
        );
    end
endgenerate

endmodule