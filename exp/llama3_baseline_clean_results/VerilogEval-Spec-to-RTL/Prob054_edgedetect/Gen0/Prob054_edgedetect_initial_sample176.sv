module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous state of the input signal
reg [7:0] pedge_reg; // register to store the output

always @ (posedge clk) begin
    prev_in <= in; // update the previous state of the input signal
    pedge_reg <= (in & ~prev_in); // detect positive edge transitions
end

assign pedge = pedge_reg; // assign the output

endmodule