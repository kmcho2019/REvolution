module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b00001; // Reset to 1
    end else begin
        q <= {q[3] ^ q[0], q[4:1]}; // Shift right and XOR tap positions
    end
end

endmodule