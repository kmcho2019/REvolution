module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] previous_state;

always @(posedge clk) begin
    previous_state <= in;
end

always @(posedge clk) begin
    anyedge <= (previous_state != in) & {8{1'b1}}; // Compare each bit and set output to 1 if there's a transition
end

endmodule