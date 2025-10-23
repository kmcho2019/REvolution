module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of 'in'
reg [7:0] pedge_reg; // Register to store the detected positive edges

always @(posedge clk) begin
    prev_in <= in; // Update the previous state on every clock cycle
    pedge_reg <= (in & (~prev_in)); // Capture the positive edges
    pedge <= pedge_reg; // Assign the captured edges to the output
end

endmodule