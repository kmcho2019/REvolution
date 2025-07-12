module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in;  // register to store previous input
reg [7:0] pedge_reg;  // register to store output

// initialize output register
initial pedge_reg = 8'd0;

always @(posedge clk) begin
    prev_in <= in;  // update previous input
    pedge_reg <= (prev_in == 8'd0) & in;  // update output
end

assign pedge = pedge_reg;  // assign output

endmodule