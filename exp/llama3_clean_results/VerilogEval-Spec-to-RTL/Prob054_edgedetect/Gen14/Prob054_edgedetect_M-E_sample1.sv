module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input vector
reg [7:0] pedge_reg;  // register to store the edge detection output

always @(posedge clk) begin
    // update the previous state
    prev_in <= in;

    // detect edges and update the output
    for (int i = 0; i < 8; i++) begin
        pedge_reg[i] <= in[i] & ~prev_in[i];
    end
end

assign pedge = pedge_reg;  // assign the output

endmodule