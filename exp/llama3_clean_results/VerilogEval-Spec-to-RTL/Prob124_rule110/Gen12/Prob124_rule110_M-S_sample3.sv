module TopModule(
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q;

integer i;
always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (i = 0; i < 512; i++) begin
            reg left, center, right;
            
            // Handle boundary conditions
            if (i == 0) begin
                left = 1'b0;
            end else begin
                left = q[i-1];
            end
            
            center = q[i];
            
            if (i == 511) begin
                right = 1'b0;
            end else begin
                right = q[i+1];
            end
            
            // Apply Rule 110 logic
            q[i] <= ~(left & center & right) & (left | center | right);
        end
    end
end

endmodule