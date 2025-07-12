module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

integer i, j, alive_neighbors;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

always @(*) begin
    next_q = q;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            alive_neighbors = 0;
            for (int x = -1; x <= 1; x = x + 1) begin
                for (int y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end
                    integer ni, nj;
                    ni = (i + x + 16) % 16;
                    nj = (j + y + 16) % 16;
                    integer index = ni * 16 + nj;
                    if (q[index]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
            integer index = i * 16 + j;
            if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
                next_q[index] = 0;
            end else if (alive_neighbors == 3) begin
                next_q[index] = 1;
            end
        end
    end
end

endmodule