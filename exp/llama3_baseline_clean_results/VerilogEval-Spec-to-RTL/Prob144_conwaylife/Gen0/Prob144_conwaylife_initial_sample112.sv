module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

integer i, j, k;
always @(*) begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg alive_neighbors;
            alive_neighbors = 0;
            for (k = -1; k <= 1; k = k + 1) begin
                for (integer l = -1; l <= 1; l = l + 1) begin
                    if ((k == 0) && (l == 0)) begin
                        // Don't count the cell itself
                        continue;
                    end
                    integer x, y;
                    x = (i + k) % 16;
                    y = (j + l) % 16;
                    if (current_state[x * 16 + y]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
            if (alive_neighbors <= 1) begin
                next_state[i * 16 + j] = 0;
            end else if (alive_neighbors == 2) begin
                next_state[i * 16 + j] = current_state[i * 16 + j];
            end else if (alive_neighbors == 3) begin
                next_state[i * 16 + j] = 1;
            end else begin
                next_state[i * 16 + j] = 0;
            end
        end
    end
    q = current_state;
end

endmodule