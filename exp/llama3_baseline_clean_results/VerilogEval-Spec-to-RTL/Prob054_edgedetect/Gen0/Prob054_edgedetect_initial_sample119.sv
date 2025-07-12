module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_in; // Register to store the previous state of the input signal

// Store the current state of the input signal in the register at each positive clock edge
always @(posedge clk) begin
    prev_in <= in;
end

// Combinational logic to detect positive edge and generate output
assign pedge = (in & (~prev_in));

endmodule