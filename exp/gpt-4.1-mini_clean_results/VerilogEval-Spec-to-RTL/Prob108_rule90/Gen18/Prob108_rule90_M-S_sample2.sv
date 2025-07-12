module TopModule (
    input  wire         clk,
    input  wire         load,
    input  wire [511:0] data,
    output reg  [511:0] q
);
    reg [511:0] next_state;

    integer i;
    always @(*) begin
        // For bit 0, left neighbor = 0, right neighbor = q[1]
        next_state[0] = 0 ^ q[1];
        // For bits 1 to 510
        for (i = 1; i < 511; i = i + 1) begin
            next_state[i] = q[i-1] ^ q[i+1];
        end
        // For bit 511, left neighbor = q[510], right neighbor = 0
        next_state[511] = q[510] ^ 0;
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_state;
    end
endmodule