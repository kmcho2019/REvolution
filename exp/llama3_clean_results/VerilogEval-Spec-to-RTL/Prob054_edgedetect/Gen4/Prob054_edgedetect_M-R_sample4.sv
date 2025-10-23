module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_in;  // Register to store the previous state of the input signal

always @(posedge clk) begin
    prev_in <= in;  // Store the current input as the previous state
    pedge <= (in & (~prev_in));  // Calculate the output directly
end

endmodule