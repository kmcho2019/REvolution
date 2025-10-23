module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

reg [511:0] q_reg;

integer i;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (i = 0; i < 512; i++) begin
            if (i == 0) begin
                // Leftmost cell
                if (q_reg[i] == 1 && q_reg[i + 1] == 1) begin
                    q_reg[i] <= 0;
                end else if (q_reg[i] == 1 && q_reg[i + 1] == 0) begin
                    q_reg[i] <= 1;
                end else if (q_reg[i] == 0 && q_reg[i + 1] == 1) begin
                    q_reg[i] <= 1;
                end else begin
                    q_reg[i] <= 0;
                end
            end else if (i == 511) begin
                // Rightmost cell
                if (q_reg[i - 1] == 1 && q_reg[i] == 1) begin
                    q_reg[i] <= 1;
                end else if (q_reg[i - 1] == 1 && q_reg[i] == 0) begin
                    q_reg[i] <= 0;
                end else if (q_reg[i - 1] == 0 && q_reg[i] == 1) begin
                    q_reg[i] <= 1;
                end else begin
                    q_reg[i] <= 0;
                end
            end else begin
                // Middle cells
                if (q_reg[i - 1] == 1 && q_reg[i] == 1 && q_reg[i + 1] == 1) begin
                    q_reg[i] <= 0;
                end else if (q_reg[i - 1] == 1 && q_reg[i] == 1 && q_reg[i + 1] == 0) begin
                    q_reg[i] <= 1;
                end else if (q_reg[i - 1] == 1 && q_reg[i] == 0 && q_reg[i + 1] == 1) begin
                    q_reg[i] <= 1;
                end else if (q_reg[i - 1] == 1 && q_reg[i] == 0 && q_reg[i + 1] == 0) begin
                    q_reg[i] <= 0;
                end else if (q_reg[i - 1] == 0 && q_reg[i] == 1 && q_reg[i + 1] == 1) begin
                    q_reg[i] <= 1;
                end else if (q_reg[i - 1] == 0 && q_reg[i] == 1 && q_reg[i + 1] == 0) begin
                    q_reg[i] <= 1;
                end else if (q_reg[i - 1] == 0 && q_reg[i] == 0 && q_reg[i + 1] == 1) begin
                    q_reg[i] <= 1;
                end else begin
                    q_reg[i] <= 0;
                end
            end
        end
    end
end

assign q = q_reg;

endmodule