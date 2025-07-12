module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous state of input signal
reg [7:0] anyedge; // output signal

always @(posedge clk) begin
    anyedge <= (in != prev_in); // detect any edge and update output
    prev_in <= in; // update previous state
end

endmodule