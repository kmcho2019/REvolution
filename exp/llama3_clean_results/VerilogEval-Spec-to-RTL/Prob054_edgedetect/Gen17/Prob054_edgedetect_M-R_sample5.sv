module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // register to store the previous state of the input vector

always @(posedge clk) begin
    prev_in <= in;  // update the previous state
    pedge <= (in & (~prev_in));  // detect 0 to 1 transition using bitwise AND and negation
end

endmodule