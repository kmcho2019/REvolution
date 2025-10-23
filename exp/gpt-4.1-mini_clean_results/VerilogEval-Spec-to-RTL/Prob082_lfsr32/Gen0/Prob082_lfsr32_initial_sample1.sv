module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback;

    // taps at bit positions 32, 22, 2, and 1 (1-based indexing)
    // which correspond to q[31], q[21], q[1], q[0] (0-based indexing)
    assign feedback = q[0] ^ q[21] ^ q[1] ^ q[31];

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            q <= {q[30:0], feedback};
        end
    end

endmodule