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
            reg left, center, right;
            if (i == 0) begin
                left = 1'b0;
                center = q_reg[i];
                right = q_reg[i+1];
            end else if (i == 511) begin
                left = q_reg[i-1];
                center = q_reg[i];
                right = 1'b0;
            end else begin
                left = q_reg[i-1];
                center = q_reg[i];
                right = q_reg[i+1];
            end
            
            // Implement the update rule
            if ((left == 1 && center == 1 && right == 1) ||
                (left == 1 && center == 0 && right == 0)) begin
                q_reg[i] <= 1'b0;
            end else begin
                q_reg[i] <= 1'b1;
            end
        end
    end
end

assign q = q_reg;

endmodule