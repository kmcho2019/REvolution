module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous input values
reg [7:0] anyedge; // register to store output values

always @ (posedge clk) begin
    // calculate output values
    anyedge <= (in != prev_in);
    // update previous input values
    prev_in <= in;
end

endmodule