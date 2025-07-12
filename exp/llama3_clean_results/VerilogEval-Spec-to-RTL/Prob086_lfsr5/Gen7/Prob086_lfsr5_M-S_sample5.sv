module TopModule(
    input clk,
    input reset,
    output reg [4:0] q
);

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        q <= 1; // Reset to a non-zero value to generate the maximum-length sequence
    end else begin
        // Shift register logic with taps at positions 5 and 3
        q <= {q[3] ^ q[0], q[4:1]};
    end
end

endmodule