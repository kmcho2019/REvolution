module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    // Define taps indices (0-based): 31, 21, 1, 0 for bits 32,22,2,1
    wire feedback;
    assign feedback = q[0] ^ q[31] ^ q[21] ^ q[1];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= {feedback, q[31:1]};
        end
    end

endmodule