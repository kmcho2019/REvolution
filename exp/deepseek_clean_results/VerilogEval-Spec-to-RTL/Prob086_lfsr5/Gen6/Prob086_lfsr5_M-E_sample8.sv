module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

wire feedback = q[4] ^ q[2];  // Taps at positions 5 and 3 (0-based: 4 and 2)

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
    end
    else begin
        q <= {q[3:0], feedback};
    end
end

endmodule