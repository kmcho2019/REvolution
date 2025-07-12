module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of 'in'

always @(posedge clk) begin
    // Compare current state of 'in' with its previous state
    pedge <= (in & (~prev_in)); // Set output bit to 1 if 0 to 1 transition is detected
    prev_in <= in; // Update the previous state register
end

endmodule