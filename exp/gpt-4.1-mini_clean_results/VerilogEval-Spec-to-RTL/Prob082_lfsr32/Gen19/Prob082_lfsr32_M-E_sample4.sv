module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback;
    wire [31:0] next_q;

    // Feedback is XOR of q[0] and tapped bits q[31], q[21], q[1], q[0]
    // The taps at bit positions 32,22,2,1 map to q[31], q[21], q[1], q[0]
    assign feedback = q[0] ^ q[31] ^ q[21] ^ q[1];

    // Construct next state bits explicitly
    // q[31] gets feedback
    // q[i] gets q[i+1] shifted right (for i=0 to 30)
    assign next_q[31] = feedback;
    assign next_q[30:0] = q[31:1];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= next_q;
        end
    end

endmodule