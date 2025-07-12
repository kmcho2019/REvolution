module TopModule (
    input clk,
    input a,
    output reg [2:0] q = 3'd4  // Initialize to 4 (100)
);

always @(posedge clk) begin
    if (a) begin
        q <= q;  // Hold when a=1
    end else begin
        // Shift register with feedback to generate sequence
        q <= {q[1] ^ q[0], q[2], q[1]};
    end
end

endmodule