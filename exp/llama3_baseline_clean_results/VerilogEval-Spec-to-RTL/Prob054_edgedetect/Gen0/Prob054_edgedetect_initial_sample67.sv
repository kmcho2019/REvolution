module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous value of 'in'
reg [7:0] pedge_reg; // Register to store the output 'pedge'

always @ (posedge clk) begin
    prev_in <= in; // Update the previous value of 'in' on each positive edge of 'clk'
    pedge_reg <= (in & (~prev_in)); // Set 'pedge' to 1 where 'in' is 1 and 'prev_in' is 0
end

assign pedge = pedge_reg; // Assign the output 'pedge' to 'pedge_reg'

initial begin
    prev_in = 8'b0; // Initialize 'prev_in' to 0
    pedge_reg = 8'b0; // Initialize 'pedge_reg' to 0
end

endmodule