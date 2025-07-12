module TopModule(
    input  clk,
    input  reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        reg [31:0] next_q;
        reg [0:0] feedback;
        
        // Calculate the feedback
        feedback = q[0] ^ q[31] ^ q[21] ^ q[1];
        
        // Shift the register right
        next_q = {feedback, q[31:1]};
        
        // Assign the next state
        q <= next_q;
    end
end

endmodule