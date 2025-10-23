module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

integer i, j;
reg [7:0] neighbours;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                neighbours = 0;
                // count neighbours
                for (integer x = -1; x <= 1; x = x + 1) begin
                    for (integer y = -1; y <= 1; y = y + 1) begin
                        if (x == 0 && y == 0) begin
                            // skip current cell
                            continue;
                        end
                        integer xi = (i + x + 16) % 16;
                        integer yi = (j + y + 16) % 16;
                        integer index = (xi * 16) + yi;
                        neighbours = neighbours + q_reg[index];
                    end
                end
                // apply game rules
                if (neighbours < 2 || neighbours > 3) begin
                    q_reg[(i * 16) + j] <= 0;
                end else if (neighbours == 3) begin
                    q_reg[(i * 16) + j] <= 1;
                end else begin
                    // no change
                end
            end
        end
    end
end

assign q = q_reg;

endmodule