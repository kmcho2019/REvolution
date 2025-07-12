module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input signal

// Generate the output based on the transition from 0 to 1
assign pedge = (in & (~prev_in));

// Store the current state of the input signal in the register at each clock cycle
always @(posedge clk) begin
    prev_in <= in;
end

endmodule