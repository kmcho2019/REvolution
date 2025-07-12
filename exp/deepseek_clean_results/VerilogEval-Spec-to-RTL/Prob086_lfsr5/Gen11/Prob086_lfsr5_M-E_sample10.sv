module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[4] ^ q[2];  // Fibonacci configuration taps

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end else begin
        q <= {q[3:0], feedback};  // Shift left with feedback at LSB
    end
end

endmodule