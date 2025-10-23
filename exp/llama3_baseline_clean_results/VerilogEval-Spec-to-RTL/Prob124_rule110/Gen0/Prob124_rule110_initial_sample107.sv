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
            if (i == 0) begin
                // left neighbor is always 0 for the first cell
                if (q_reg[i] == 1'b1 && q_reg[i + 1] == 1'b1) begin
                    q_reg[i] <= 1'b0;
                end else if (q_reg[i] == 1'b1 && q_reg[i + 1] == 1'b0) begin
                    q_reg[i] <= 1'b1;
                end else if (q_reg[i] == 1'b0 && q_reg[i + 1] == 1'b1) begin
                    q_reg[i] <= 1'b1;
                end else begin
                    q_reg[i] <= 1'b0;
                end
            end else if (i == 511) begin
                // right neighbor is always 0 for the last cell
                if (q_reg[i] == 1'b1 && q_reg[i - 1] == 1'b1) begin
                    q_reg[i] <= 1'b1;
                end else if (q_reg[i] == 1'b1 && q_reg[i - 1] == 1'b0) begin
                    q_reg[i] <= 1'b1;
                end else if (q_reg[i] == 1'b0 && q_reg[i - 1] == 1'b1) begin
                    q_reg[i] <= 1'b1;
                end else begin
                    q_reg[i] <= 1'b0;
                end
            end else begin
                // for all other cells
                if (q_reg[i - 1] == 1'b1 && q_reg[i] == 1'b1 && q_reg[i + 1] == 1'b1) begin
                    q_reg[i] <= 1'b0;
                end else if (q_reg[i - 1] == 1'b1 && q_reg[i] == 1'b1 && q_reg[i + 1] == 1'b0) begin
                    q_reg[i] <= 1'b1;
                end else if (q_reg[i - 1] == 1'b1 && q_reg[i] == 1'b0 && q_reg[i + 1] == 1'b1) begin
                    q_reg[i] <= 1'b1;
                end else if (q_reg[i - 1] == 1'b1 && q_reg[i] == 1'b0 && q_reg[i + 1] == 1'b0) begin
                    q_reg[i] <= 1'b0;
                end else if (q_reg[i - 1] == 1'b0 && q_reg[i] == 1'b1 && q_reg[i + 1] == 1'b1) begin
                    q_reg[i] <= 1'b1;
                end else if (q_reg[i - 1] == 1'b0 && q_reg[i] == 1'b1 && q_reg[i + 1] == 1'b0) begin
                    q_reg[i] <= 1'b1;
                end else if (q_reg[i - 1] == 1'b0 && q_reg[i] == 1'b0 && q_reg[i + 1] == 1'b1) begin
                    q_reg[i] <= 1'b1;
                end else begin
                    q_reg[i] <= 1'b0;
                end
            end
        end
    end
end

assign q = q_reg;

endmodule