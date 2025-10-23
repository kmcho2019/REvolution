module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

wire [511:0] next_q;

// Combinational logic for next state
always @(*) begin
    // Left boundary (i=0)
    next_q[0] = 1'b0 ^ q[1];
    
    // Right boundary (i=511)
    next_q[511] = q[510] ^ 1'b0;
    
    // Internal cells (i=1 to 510)
    for (integer i = 1; i < 511; i = i + 1) begin
        next_q[i] = q[i-1] ^ q[i+1];
    end
end

// Sequential update
always @(posedge clk) begin
    q <= load ? data : next_q;
end

endmodule