module TopModule(
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 512; i++) begin
            wire left, right, next_state;
            if (i == 0) begin
                assign left = 1'b0;
                assign right = q_reg[i + 1];
            end else if (i == 511) begin
                assign left = q_reg[i - 1];
                assign right = 1'b0;
            end else begin
                assign left = q_reg[i - 1];
                assign right = q_reg[i + 1];
            end
            assign next_state = left ^ right;
            q_reg[i] <= next_state;
        end
    end
end

assign q = q_reg;

endmodule