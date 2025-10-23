// Refactored TopModule with Simplified Shift Register Implementation
module TopModule(
    input clk,
    input resetn,
    input in,
    output reg out
);

reg [3:0] q; // Internal state of the shift register

always @(posedge clk) begin
    if (!resetn) begin
        q <= 4'b0000; // Reset the state to zero
    end else begin
        q <= {q[2:0], in}; // Shift the state and update with the input
    end
end

assign out = q[3]; // Output is the most significant bit of the state

endmodule