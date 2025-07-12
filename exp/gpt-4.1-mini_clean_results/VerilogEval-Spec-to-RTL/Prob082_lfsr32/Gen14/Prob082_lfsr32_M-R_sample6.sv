module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire feedback = q[0];
    wire [31:0] next_q;

    assign next_q = feedback ? ((q >> 1) ^ (32'h80000000 | 32'h00200000 | 32'h00000002 | 32'h00000001)) : (q >> 1);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule