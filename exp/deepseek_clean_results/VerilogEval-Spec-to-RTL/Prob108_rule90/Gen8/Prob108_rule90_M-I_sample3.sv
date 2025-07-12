module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] state;

    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            // Apply Rule 90 to all cells in parallel
            // Left boundary (state[-1]) is 0
            state[0] <= 0 ^ state[1];
            
            // Middle cells
            for (integer i = 1; i < 511; i = i + 1) begin
                state[i] <= state[i-1] ^ state[i+1];
            end
            
            // Right boundary (state[512]) is 0
            state[511] <= state[510] ^ 0;
        end
    end

    // Continuous assignment for output
    assign q = state;

endmodule