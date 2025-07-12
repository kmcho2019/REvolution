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
                // Get neighbors with boundary conditions
                bit left = (i == 511) ? 1'b0 : q[i+1];
                bit right = (i == 0) ? 1'b0 : q[i-1];
                
                // Simplified Rule 110 logic (all cases where next state is 1)
                q[i] <= (left & ~right) | (~left & (q[i] | right));
            end
        end
    end

endmodule