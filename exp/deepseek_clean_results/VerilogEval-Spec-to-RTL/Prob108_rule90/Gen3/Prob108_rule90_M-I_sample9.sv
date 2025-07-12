module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] q_next;

    // Combinational logic for Rule 90 with boundary conditions
    always @(*) begin
        for (int i = 0; i < 512; i = i + 1) begin
            // Boundary conditions: q[-1] and q[512] are 0
            q_next[i] = (i == 0 ? 0 : q[i-1]) ^ (i == 511 ? 0 : q[i+1]);
        end
    end

    // Sequential update
    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= q_next;
        end
    end

endmodule