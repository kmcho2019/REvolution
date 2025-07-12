module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0] ^ q[31] ^ q[21] ^ q[1];

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= {feedback, q[31:1]};
    end

endmodule