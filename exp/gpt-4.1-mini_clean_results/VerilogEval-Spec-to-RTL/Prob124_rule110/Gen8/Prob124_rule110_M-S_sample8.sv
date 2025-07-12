module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    wire [513:0] q_ext = {1'b0, q, 1'b0};

    // next_q[i] = (~left & center) | (center ^ right)
    // left = q_ext[i+2], center = q_ext[i+1], right = q_ext[i]
    wire [511:0] next_q = (~q_ext[511:0] & q_ext[512:1]) | (q_ext[512:1] ^ q_ext[511:0]);

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule