module TopModule (
    input clk,
    input reset,
    output reg [3:0] q
);

    wire feedback;

    // Feedback is XOR of all current q bits
    assign feedback = q[3] ^ q[2] ^ q[1] ^ q[0];

    always @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            q <= {q[2:0], feedback}; // Shift left, insert feedback bit at LSB
        end
    end
endmodule