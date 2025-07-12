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
            for (integer i = 0; i < 512; i = i + 1) begin
                // Boundary conditions (q[-1] and q[512] are 0)
                reg left = (i == 511) ? 1'b0 : q[i+1];
                reg right = (i == 0) ? 1'b0 : q[i-1];
                
                // Rule 110 logic
                q[i] <= (q[i] ^ (left & right)) | (~left & right);
            end
        end
    end

endmodule