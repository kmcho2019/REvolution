module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_state;  // register to store previous state of input signal
reg [7:0] anyedge;    // output register

always @(posedge clk) begin
    // update previous state
    prev_state <= in;

    // detect any edge and update output
    anyedge <= (in !== prev_state);
end

endmodule