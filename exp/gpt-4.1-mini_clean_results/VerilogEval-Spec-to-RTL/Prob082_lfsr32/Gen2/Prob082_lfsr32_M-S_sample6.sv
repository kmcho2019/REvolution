module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | (1 << 0);

    always @(posedge clk) begin
        if (reset) begin
            q <= 32'h1;
        end else begin
            reg feedback;
            feedback = q[0];
            q <= {feedback, (q >> 1) ^ (TAP_MASK & {32{feedback}})};
        end
    end

endmodule