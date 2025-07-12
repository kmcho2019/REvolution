module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

integer i, j;
integer neighbors;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                neighbors = 0;
                for (integer x = -1; x <= 1; x = x + 1) begin
                    for (integer y = -1; y <= 1; y = y + 1) begin
                        if ((x == 0) && (y == 0)) begin
                            // skip the current cell
                            continue;
                        end else begin
                            integer ni, nj;
                            ni = (i + x + 16) % 16;
                            nj = (j + y + 16) % 16;
                            if (q_reg[ni*16 + nj]) begin
                                neighbors = neighbors + 1;
                            end
                        end
                    end
                end
                if (neighbors == 2) begin
                    // cell state does not change
                    q_reg[i*16 + j] <= q_reg[i*16 + j];
                end else if (neighbors == 3) begin
                    // cell becomes 1
                    q_reg[i*16 + j] <= 1;
                end else begin
                    // cell becomes 0
                    q_reg[i*16 + j] <= 0;
                end
            end
        end
    end
end

assign q = q_reg;

endmodule