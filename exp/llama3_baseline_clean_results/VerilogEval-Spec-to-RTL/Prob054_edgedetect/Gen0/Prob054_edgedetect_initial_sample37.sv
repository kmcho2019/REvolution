module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous state of in
reg [7:0] pedge_reg; // register to store the output

always @(posedge clk) begin
    prev_in <= in; // update previous state at every positive clock edge
    pedge_reg <= (in & (~prev_in)); // detect 0 to 1 transition
end

assign pedge = pedge_reg; // assign output

endmodule