module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state; // register to store previous state of input vector
reg [7:0] pedge_reg; // register to store output

always @ (posedge clk) begin
    pedge_reg <= (in & ~(prev_state)); // set output bit to 1 when 0->1 transition occurs
    prev_state <= in; // update previous state
end

assign pedge = pedge_reg; // assign output register to output port

endmodule