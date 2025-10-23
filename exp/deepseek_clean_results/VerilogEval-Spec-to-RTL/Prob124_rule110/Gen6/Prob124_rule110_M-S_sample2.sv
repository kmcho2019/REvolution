module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;
    integer i;

    always @(*) begin
        // Handle boundary conditions
        next_q[0] = (1'b0 & q[0] & ~q[1]) || (1'b0 & ~q[0] & q[1]) || (~1'b0 & q[0]) || (~1'b0 & ~q[0] & q[1]);
        next_q[511] = (q[510] & q[511] & ~1'b0) || (q[510] & ~q[511] & 1'b0) || (~q[510] & q[511]) || (~q[510] & ~q[511] & 1'b0);

        // Handle middle cells
        for (i = 1; i < 511; i = i + 1) begin
            next_q[i] = (q[i-1] & q[i] & ~q[i+1]) || 
                       (q[i-1] & ~q[i] & q[i+1]) || 
                       (~q[i-1] & q[i]) || 
                       (~q[i-1] & ~q[i] & q[i+1]);
        end
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule