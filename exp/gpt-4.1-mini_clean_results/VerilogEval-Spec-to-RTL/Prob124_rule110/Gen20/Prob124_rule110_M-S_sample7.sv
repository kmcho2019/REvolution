module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);

    // Extend q with zero padding for boundaries
    wire [513:0] ext_q = {1'b0, q, 1'b0};

    integer i;
    reg [511:0] next_q;

    always @(*) begin
        for (i = 0; i < 512; i = i + 1) begin
            // Rule 110: next state bit is ((~left & center) | (center ^ right))
            // left = ext_q[i+2], center = ext_q[i+1], right = ext_q[i]
            next_q[i] = (~ext_q[i+2] & ext_q[i+1]) | (ext_q[i+1] ^ ext_q[i]);
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule