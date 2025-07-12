module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b10000; // Reset the LFSR to a known state
    end else begin
        q <= {q[3] ^ q[0], q[4:1]}; // Shift right and apply taps
    end
end

endmodule