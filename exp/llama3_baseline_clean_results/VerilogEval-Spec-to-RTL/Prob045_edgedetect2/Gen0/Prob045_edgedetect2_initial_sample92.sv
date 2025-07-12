module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous state of input signal
reg [7:0] anyedge_reg; // register to store output signal

always @ (posedge clk) begin
    prev_in <= in; // update previous state at each positive edge of clock
    anyedge_reg <= in ^ prev_in; // detect any edge by XORing current and previous states
end

assign anyedge = anyedge_reg; // assign output signal

endmodule