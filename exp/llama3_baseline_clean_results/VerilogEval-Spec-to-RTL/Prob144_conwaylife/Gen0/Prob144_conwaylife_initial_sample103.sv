module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] next_q;

integer i, j;
reg [3:0] neighbors;

always @(*) begin
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbors = 0;
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) begin
                        continue;
                    end else begin
                        neighbors = neighbors + q[((((i + x) % 16) * 16) + ((j + y) % 16))];
                    end
                end
            end
            if (neighbors == 2) begin
                next_q[((i * 16) + j)] = q[((i * 16) + j)];
            end else if (neighbors == 3) begin
                next_q[((i * 16) + j)] = 1;
            end else begin
                next_q[((i * 16) + j)] = 0;
            end
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        q <= next_q;
    end
end

endmodule