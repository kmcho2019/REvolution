module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input signal
reg [7:0] pedge_reg; // Register to store the output signal

always @(posedge clk) begin
    // Store the current input state in the previous input register
    prev_in <= in;
    // Set the output bits based on the transition detection
    pedge_reg <= (in & (~prev_in));
end

assign pedge = pedge_reg;

endmodule