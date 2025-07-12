module EdgeDetect(
    input clk,
    input in,
    output reg pedge
);

reg prev_in;  // register to store the previous state of the input signal
reg pedge_reg;  // internal register to hold the edge detection result

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    pedge_reg <= (in == 1'b1) && (prev_in == 1'b0);  // detect 0 to 1 transition
    pedge <= pedge_reg;  // assign the edge detection result to the output
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