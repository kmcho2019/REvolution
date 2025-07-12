module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous input value
reg [7:0] anyedge_reg; // internal register for anyedge output

// update previous input value on every clock cycle
always @(posedge clk) begin
    prev_in <= in;
    anyedge_reg <= (in !== prev_in); // detect edge and update output
end

// assign output
assign anyedge = anyedge_reg;

endmodule