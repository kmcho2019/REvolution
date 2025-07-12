module TopModule(
    input clk,
    input [7:0] in,
    output reg [7:0] pedge
);

reg [7:0] prev_state;

always @(posedge clk) begin
    // Update the previous state
    prev_state <= in;
    
    // Calculate the output based on the current input and the previous state
    // A positive edge is detected when the current input bit is 1 and the corresponding previous state bit is 0
    pedge <= in & ~prev_state;
end

endmodule