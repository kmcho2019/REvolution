module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_state;
    integer i;

    always @* begin
        // Compute next_state bits according to Rule 90 with zero boundary
        // bit 0
        next_state[0] = 1'b0 ^ q[1];
        // bits 1 to 510
        for (i = 1; i < 511; i = i + 1) begin
            next_state[i] = q[i-1] ^ q[i+1];
        end
        // bit 511
        next_state[511] = q[510] ^ 1'b0;
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end

endmodule