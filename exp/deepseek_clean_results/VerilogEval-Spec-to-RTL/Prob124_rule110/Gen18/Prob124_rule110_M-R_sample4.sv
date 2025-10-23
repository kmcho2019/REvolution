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
            // Handle boundary conditions and apply Rule 110
            q[511] <= (q[511] ^ (1'b0 & q[510])) | (~1'b0 & q[510]);  // Left neighbor is 0
            q[0] <= (q[0] ^ (q[1] & 1'b0)) | (~q[1] & 1'b0);          // Right neighbor is 0
            
            // Middle bits
            for (integer i = 1; i < 511; i = i + 1) begin
                q[i] <= (q[i] ^ (q[i+1] & q[i-1])) | (~q[i+1] & q[i-1]);
            end
        end
    end

endmodule