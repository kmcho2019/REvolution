module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    wire [31:0] next_q;
    wire feedback = q[0];
    localparam [31:0] TAP_MASK = 32'h80200003;

    assign next_q = (q >> 1) ^ ({32{feedback}} & TAP_MASK);

    always @(posedge clk) begin
        if (reset)
            q <= 32'h1;
        else
            q <= next_q;
    end

endmodule