module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    reg [511:0] next_state;

    integer i;
    always @(*) begin
        // Compute next state based on current q
        // For each cell, next_state[i] = q[i-1] ^ q[i+1], with boundaries = 0
        next_state[0] = q[1];
        for (i = 1; i < 511; i = i + 1) begin
            next_state[i] = q[i-1] ^ q[i+1];
        end
        next_state[511] = q[510];
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_state;
        end
    end
endmodule