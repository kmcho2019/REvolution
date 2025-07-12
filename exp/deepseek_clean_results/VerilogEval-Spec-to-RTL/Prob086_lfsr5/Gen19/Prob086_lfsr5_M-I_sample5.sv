module TopModule (
    input clk,
    input reset,
    input enable,
    output reg [4:0] q
);

reg feedback;

always @(posedge clk) begin
    if (reset) begin
        q <= 5'b00001;
        feedback <= 1'b0;
    end
    else if (enable) begin
        // First stage: compute feedback
        feedback <= q[3] ^ q[0];
        
        // Second stage: apply shift with pipelined feedback
        q <= {q[0], q[4], feedback, q[2], q[1]};
    end
end

endmodule