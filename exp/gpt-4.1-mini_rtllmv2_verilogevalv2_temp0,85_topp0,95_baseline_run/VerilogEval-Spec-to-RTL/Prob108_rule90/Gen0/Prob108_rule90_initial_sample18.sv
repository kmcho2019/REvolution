module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            // Calculate next state using Rule 90
            // Left neighbors: for i=0 left = 0, for others q[i-1]
            // Right neighbors: for i=511 right = 0, else q[i+1]
            q <= {q[510:0] ^ q[512-511:511]}; // wait, this is confusing, write explicitly
            // Let's build next state explicitly:
            // For bit 0: next = 0 ^ q[1]
            // For bit 511: next = q[510] ^ 0
            // For bits [1..510]: next = q[i-1] ^ q[i+1]
            integer i;
            reg [511:0] next_q;
            for (i=0; i<512; i=i+1) begin
                reg left, right;
                left  = (i==0)     ? 1'b0 : q[i-1];
                right = (i==511)   ? 1'b0 : q[i+1];
                next_q[i] = left ^ right;
            end
            q <= next_q;
        end
    end

endmodule