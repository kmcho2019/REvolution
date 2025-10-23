module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

reg [31:0] nextState;

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg feedback;
        feedback = q[0] ^ q[1] ^ q[21] ^ q[31];
        nextState = {feedback, q[31:1]};
        q <= nextState;
    end
end

endmodule