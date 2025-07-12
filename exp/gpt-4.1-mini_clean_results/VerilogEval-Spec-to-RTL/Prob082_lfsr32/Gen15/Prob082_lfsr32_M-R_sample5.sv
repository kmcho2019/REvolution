module TopModule (
    input clk,
    input reset,
    output reg [31:0] q
);

    localparam [31:0] TAP_MASK = (1 << 31) | (1 << 21) | (1 << 1) | 1;
    wire feedback = q[0];
    wire [31:0] next_q = (q >> 1) ^ (feedback ? TAP_MASK : 0);

    always @(posedge clk) begin
        if (reset) 
            q <= 32'h1;
        else 
            q <= next_q;
    end

endmodule