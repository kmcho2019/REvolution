module TopModule(
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

reg [7:0] prev_in; // register to store previous value of 'in'

always @(posedge clk) begin
    // Update 'prev_in' with the current value of 'in'
    prev_in <= in;
end

always @(*) begin
    // Use XOR operation to detect any edge transitions
    anyedge <= in ^ prev_in;
end

endmodule