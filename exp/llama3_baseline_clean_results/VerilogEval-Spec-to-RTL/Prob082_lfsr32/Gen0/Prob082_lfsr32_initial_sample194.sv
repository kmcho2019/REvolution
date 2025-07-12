module TopModule (
    input  clk,
    input  reset,
    output [31:0] q
);

reg [31:0] q;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // calculate feedback term
        reg [0:0] feedback;
        feedback = q[0] ^ q[22] ^ q[1] ^ q[31];
        
        // shift q to the right and XOR with feedback
        q <= {q[30:0], feedback};
    end
end

endmodule