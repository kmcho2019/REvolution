module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

reg [7:0] prev_state = 8'b0;

always @(posedge clk) begin
    pedge <= (in & (~prev_state)); // Check for positive edge transition
    prev_state <= in; // Update previous state
end

endmodule