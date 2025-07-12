module TopModule(
    input clk,
    input reset,
    output reg [31:0] q
);

always @(posedge clk) begin
    if (reset) begin
        q <= 32'h1;
    end else begin
        // Calculate the feedback
        wire feedback;
        assign feedback = q[0] ^ q[1] ^ q[21] ^ q[31];

        // Shift the register to the right
        reg [31:0] next_q;
        next_q[31:1] = q[30:0];

        // Apply the feedback to the bits at the tap positions
        next_q[0] = feedback;

        // Assign the next state to q
        q <= next_q;
    end
end

endmodule