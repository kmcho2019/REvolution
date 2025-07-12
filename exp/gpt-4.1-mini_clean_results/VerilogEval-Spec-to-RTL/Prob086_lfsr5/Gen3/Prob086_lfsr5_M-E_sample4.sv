module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    reg feedback;

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001;  // synchronous reset to 1
        end else begin
            // feedback is XOR of q[0] with taps at q[2] and q[4]
            feedback = q[0] ^ q[2] ^ q[4];
            // shift right and load feedback into MSB
            q <= {feedback, q[4:1]};
        end
    end

endmodule