module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

// Direct calculation of next_state considering boundary conditions
assign q = q_reg;
always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            reg left, center, right;
            // Simplified boundary conditions
            assign left = (i == 0)? 1'b0 : q_reg[i - 1];
            assign center = q_reg[i];
            assign right = (i == 511)? 1'b0 : q_reg[i + 1];
            
            // Apply Rule 90 logic directly
            q_reg[i] <= left ^ right;
        end
    end
end

endmodule