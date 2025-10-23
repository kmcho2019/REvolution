module TopModule(
    input clk,
    input reset,
    output [4:0] q
);

reg [4:0] q;

always @ (posedge clk or posedge reset) begin
    if (reset) begin
        q <= 5'b10000;  // initialize to 1
    end else begin
        q <= {q[3] ^ q[0], q[4:1]};  // LFSR logic with taps at positions 4 and 2
    end
end

endmodule