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
            // Handle first bit (right neighbor is 0)
            q[0] <= (q[1] & q[0]) ^ 1'b0;
            
            // Handle middle bits
            for (integer i = 1; i < 511; i = i + 1) begin
                q[i] <= (q[i+1] & q[i]) ^ q[i-1];
            end
            
            // Handle last bit (left neighbor is 0)
            q[511] <= (1'b0 & q[511]) ^ q[510];
        end
    end

endmodule