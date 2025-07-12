module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q;
reg [255:0] next_q;

integer i, j, k;

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        for (i = 0; i < 256; i++) begin
            next_q[i] = q[i];
        end
        for (i = 0; i < 16; i++) begin
            for (j = 0; j < 16; j++) begin
                reg [2:0] neighbors;
                neighbors = 0;
                for (k = -1; k <= 1; k++) begin
                    for (integer l = -1; l <= 1; l++) begin
                        if (k == 0 && l == 0) begin
                            continue;
                        end
                        integer row, col;
                        row = (i + k + 16) % 16;
                        col = (j + l + 16) % 16;
                        neighbors += q[row * 16 + col];
                    end
                end
                integer index;
                index = i * 16 + j;
                if (neighbors < 2 || neighbors > 3) begin
                    next_q[index] = 0;
                end else if (neighbors == 3) begin
                    next_q[index] = 1;
                end
            end
        end
        q <= next_q;
    end
end

endmodule