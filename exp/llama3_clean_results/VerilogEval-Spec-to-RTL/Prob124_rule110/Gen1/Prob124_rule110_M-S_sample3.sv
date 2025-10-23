module TopModule(
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
            // Handle boundaries
            left = (i == 0) ? 0 : q_reg[i-1];
            center = q_reg[i];
            right = (i == 511) ? 0 : q_reg[i+1];
            // Apply Rule 110
            q_reg[i] <= (left && center && right) ? 0 :
                         (left && center && !right) ? 1 :
                         (left && !center && right) ? 1 :
                         (left && !center && !right) ? 0 :
                         (!left && center && right) ? 1 :
                         (!left && center && !right) ? 1 :
                         (!left && !center && right) ? 1 :
                         (!left && !center && !right) ? 0 : 0;
        end
    end
end

assign q = q_reg;

endmodule