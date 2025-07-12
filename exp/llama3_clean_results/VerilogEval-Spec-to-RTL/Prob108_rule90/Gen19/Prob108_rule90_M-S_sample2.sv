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
            wire left, center, right;
            assign left = (i == 0) ? 1'b0 : q_reg[i - 1];
            assign center = q_reg[i];
            assign right = (i == 511) ? 1'b0 : q_reg[i + 1];
            
            // Apply Rule 90 logic directly
            q_reg[i] <= (left == 1 && center == 1 && right == 1) ? 1'b0 :
                         (left == 1 && center == 1 && right == 0) ? 1'b1 :
                         (left == 1 && center == 0 && right == 1) ? 1'b0 :
                         (left == 1 && center == 0 && right == 0) ? 1'b1 :
                         (left == 0 && center == 1 && right == 1) ? 1'b1 :
                         (left == 0 && center == 1 && right == 0) ? 1'b0 :
                         (left == 0 && center == 0 && right == 1) ? 1'b1 :
                         (left == 0 && center == 0 && right == 0) ? 1'b0 : 1'b0;
        end
    end
end

assign q = q_reg;

endmodule