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
            // Boundary bits
            q[0] <= q[1];          // 0 ^ q[1]
            q[511] <= q[510];       // q[510] ^ 0
            
            // Internal bits using generate for compact implementation
            genvar i;
            for (i = 1; i < 511; i = i + 1) begin
                q[i] <= q[i-1] ^ q[i+1];
            end
        end
    end

endmodule