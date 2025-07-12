module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // register to store the previous value of 'in'

always @ (posedge clk) begin
    prev_in <= in; // update the previous value of 'in' on each clock cycle
end

assign pedge = (in & ~prev_in); // set 'pedge' to 1 where 'in' is 1 and 'prev_in' is 0

endmodule