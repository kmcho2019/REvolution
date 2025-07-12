module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_value; // D flip-flop to store previous values
reg [7:0] anyedge;   // output register

always @(posedge clk) begin
    // compare current value with previous value
    anyedge <= (in != prev_value);
    // update previous value for next clock cycle
    prev_value <= in;
end

endmodule