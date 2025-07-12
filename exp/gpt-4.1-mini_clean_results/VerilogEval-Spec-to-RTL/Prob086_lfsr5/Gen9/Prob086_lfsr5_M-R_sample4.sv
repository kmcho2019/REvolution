module TopModule (
    input        clk,
    input        reset,
    output reg [4:0] q
);

    // Compute feedback from taps at bit positions 5 and 3 (q[4], q[2]) and q[0]
    wire feedback = q[0] ^ q[2];

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b00001; // synchronous reset to 1
        end else begin
            // Shift right and apply feedback to tapped positions
            q <= {feedback, q[4], q[3] ^ feedback, q[2], q[1]};
        end
    end

endmodule