module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in;  // register to store the previous input vector
reg [7:0] anyedge;  // output register

always @(posedge clk) begin
    // detect any edge
    anyedge <= (in != prev_in);
    // update previous state
    prev_in <= in;
end

endmodule