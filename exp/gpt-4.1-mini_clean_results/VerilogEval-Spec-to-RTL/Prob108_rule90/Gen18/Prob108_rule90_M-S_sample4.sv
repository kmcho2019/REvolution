module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    reg [511:0] next_state;
    integer i;

    always @* begin
        // Boundary bits: left neighbor of bit 0 is 0, right neighbor of bit 511 is 0
        next_state[0]   = 1'b0 ^ q[1];
        next_state[511] = q[510] ^ 1'b0;
        // Compute next state for bits 1 through 510
        for (i = 1; i < 511; i = i + 1) begin
            next_state[i] = q[i-1] ^ q[i+1];
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule