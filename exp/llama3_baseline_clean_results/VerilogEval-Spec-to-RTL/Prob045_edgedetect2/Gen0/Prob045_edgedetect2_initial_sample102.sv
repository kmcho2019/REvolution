module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous input state
reg [7:0] anyedge_reg; // register to store output

always @(posedge clk) begin
    prev_in <= in; // store current input as previous input
    anyedge_reg <= (in ^ prev_in); // detect edge transitions
end

assign anyedge = anyedge_reg; // assign output

initial begin
    prev_in = 8'd0; // initialize previous input state
    anyedge_reg = 8'd0; // initialize output register
end

endmodule