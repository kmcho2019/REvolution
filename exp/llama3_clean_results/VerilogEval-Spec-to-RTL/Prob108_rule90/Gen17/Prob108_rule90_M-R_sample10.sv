module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            // Determine left and right neighbors, handling boundary conditions implicitly
            wire left = (i == 0)? 1'b0 : q_reg[i - 1];
            wire right = (i == 511)? 1'b0 : q_reg[i + 1];
            
            // Apply Rule 90 logic directly
            q_reg[i] <= left ^ right;
        end
    end
end

assign q = q_reg;

endmodule