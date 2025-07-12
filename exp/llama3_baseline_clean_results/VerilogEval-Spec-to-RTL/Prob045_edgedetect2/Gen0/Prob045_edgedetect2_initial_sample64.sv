module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;

always @(posedge clk) begin
    anyedge <= (in != prev_in); // anyedge is 1 where in has changed
    prev_in <= in; // update previous state for next cycle
end

endmodule