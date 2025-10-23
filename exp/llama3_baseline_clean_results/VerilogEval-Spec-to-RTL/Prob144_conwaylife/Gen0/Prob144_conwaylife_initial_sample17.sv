module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [255:0] next_state;
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                integer alive_neighbors;
                alive_neighbors = 0;
                for (integer x = -1; x <= 1; x = x + 1) begin
                    for (integer y = -1; y <= 1; y = y + 1) begin
                        if ((x == 0) && (y == 0)) begin
                            continue;
                        end
                        integer xi, yi;
                        xi = (i + x + 16) % 16;
                        yi = (j + y + 16) % 16;
                        integer idx;
                        idx = xi * 16 + yi;
                        if (q_reg[idx]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end
                integer idx;
                idx = i * 16 + j;
                if ((alive_neighbors <= 1) || (alive_neighbors >= 4)) begin
                    next_state[idx] <= 0;
                end else if (alive_neighbors == 2) begin
                    next_state[idx] <= q_reg[idx];
                end else if (alive_neighbors == 3) begin
                    next_state[idx] <= 1;
                end
            end
        end
        q_reg <= next_state;
    end
    q <= q_reg;
end

endmodule