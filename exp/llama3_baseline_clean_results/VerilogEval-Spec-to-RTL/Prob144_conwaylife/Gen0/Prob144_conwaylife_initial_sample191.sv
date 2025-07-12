module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

assign q = q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbors;
                neighbors = count_neighbors(q_reg, i, j);
                if (neighbors < 2 || neighbors > 3) begin
                    q_reg[16*i + j] <= 1'b0;
                end else if (neighbors == 3) begin
                    q_reg[16*i + j] <= 1'b1;
                end else begin
                    q_reg[16*i + j] <= q_reg[16*i + j];
                end
            end
        end
    end
end

function reg [2:0] count_neighbors;
    input [255:0] grid;
    input [3:0] row;
    input [3:0] col;
    reg [2:0] neighbors;
    reg [3:0] r, c;
    neighbors = 3'b000;
    for (int i = -1; i <= 1; i++) begin
        for (int j = -1; j <= 1; j++) begin
            if (i == 0 && j == 0) begin
                continue;
            end
            r = (row + i + 16) % 16;
            c = (col + j + 16) % 16;
            if (grid[16*r + c] == 1'b1) begin
                neighbors <= neighbors + 1'b1;
            end
        end
    end
    return neighbors;
endfunction

endmodule