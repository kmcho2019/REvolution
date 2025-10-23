module TopModule(
    input clk,
    input reset,
    input [31:0] in,
    output reg [31:0] out
);

reg [31:0] prev_in;

always @(posedge clk) begin
    if (reset) begin
        out <= 32'b0;
        prev_in <= 32'b0;
    end else begin
        out <= out | (~in & prev_in); // Set out bit if in transitions from 1 to 0
        prev_in <= in; // Update previous input state
    end
end

endmodule