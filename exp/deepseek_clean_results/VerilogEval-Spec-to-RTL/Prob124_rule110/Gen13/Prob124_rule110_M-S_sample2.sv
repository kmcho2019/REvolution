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
                // Boundary conditions: left/right neighbors are 0 when out of bounds
                reg left = (i < 511) ? q[i+1] : 1'b0;
                reg right = (i > 0) ? q[i-1] : 1'b0;
                
                // Direct implementation of Rule 110 logic
                q[i] <= (q[i] ^ right) | (~left & (q[i] | right));
            end
        end
    end

endmodule