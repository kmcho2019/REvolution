module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

// Combinational logic to calculate the next state
always @(*) begin
    if (reset) begin
        q = 32'h1; // Reset to 1
    end else begin
        q = {q[0] ^ q[21] ^ q[1] ^ q[30], q[31:1]}; // Shift right and apply taps
    end
end

endmodule