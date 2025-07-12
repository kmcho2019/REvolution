module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);
    integer i;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Compute next_state using Rule 90
            // Boundaries assumed zero: q[-1] = 0, q[512] = 0
            next_state[0] = q[1]; // left neighbor q[-1]=0 XOR q[1]
            for (i = 1; i < 511; i = i + 1) begin
                next_state[i] = q[i-1] ^ q[i+1];
            end
            next_state[511] = q[510]; // right neighbor q[512]=0 XOR q[510]
            q <= next_state;
        end
    end
endmodule