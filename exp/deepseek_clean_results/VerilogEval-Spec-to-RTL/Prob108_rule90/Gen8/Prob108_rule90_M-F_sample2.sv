module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

// Next state computation with explicit boundary handling
wire [511:0] next_q;
integer i;
always @(*) begin
    for (i = 0; i < 512; i = i + 1) begin
        case (i)
            0: next_q[i] = 1'b0 ^ q[i+1];       // Left boundary = 0
            511: next_q[i] = q[i-1] ^ 1'b0;     // Right boundary = 0
            default: next_q[i] = q[i-1] ^ q[i+1]; // Normal case
        endcase
    end
end

// Sequential update
always @(posedge clk) begin
    if (load)
        q <= data;
    else
        q <= next_q;
end

endmodule