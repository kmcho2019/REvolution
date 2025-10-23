module EdgeDetect(
    input clk,
    input in,
    output reg pedge
);

reg prev_in;  // register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    pedge <= (in == 1'b1) && (prev_in == 1'b0);  // detect 0 to 1 transition
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