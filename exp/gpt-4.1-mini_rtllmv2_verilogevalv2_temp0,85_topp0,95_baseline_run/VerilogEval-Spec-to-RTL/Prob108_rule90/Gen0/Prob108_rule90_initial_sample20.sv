module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(*) begin
        // Compute next state according to Rule 90 with boundary zeros
        integer i;

        // Bit 0: q[-1] = 0, so next_q[0] = 0 ^ q[1] = q[1]
        next_q[0] = q[1];

        // For bits 1 to 510: next_q[i] = q[i-1] ^ q[i+1]
        for (i = 1; i < 511; i = i + 1) begin
            next_q[i] = q[i-1] ^ q[i+1];
        end

        // Bit 511: q[512] = 0, so next_q[511] = q[510] ^ 0 = q[510]
        next_q[511] = q[510];
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule