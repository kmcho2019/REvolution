module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] next_q;

    always @(*) begin
        // Handle first bit (left neighbor is 0)
        next_q[0] = 1'b0 ^ q[1];
        
        // Handle middle bits
        for (integer i = 1; i < 511; i = i + 1) begin
            next_q[i] = q[i-1] ^ q[i+1];
        end
        
        // Handle last bit (right neighbor is 0)
        next_q[511] = q[510] ^ 1'b0;
    end

    always @(posedge clk) begin
        if (load) begin
            q <= data;
        end else begin
            q <= next_q;
        end
    end

endmodule