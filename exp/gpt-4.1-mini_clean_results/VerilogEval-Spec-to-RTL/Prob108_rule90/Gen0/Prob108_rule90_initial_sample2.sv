module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @* begin
        // For each bit, next state is XOR of neighbors with boundary 0
        next_q[0] = q[1] ^ 1'b0;
        next_q[511] = q[510] ^ 1'b0;
        integer i;
        for (i = 1; i < 511; i = i + 1) begin
            next_q[i] = q[i-1] ^ q[i+1];
        end
    end

    always @(posedge clk) begin
        if (load)
            q <= data;
        else
            q <= next_q;
    end

endmodule