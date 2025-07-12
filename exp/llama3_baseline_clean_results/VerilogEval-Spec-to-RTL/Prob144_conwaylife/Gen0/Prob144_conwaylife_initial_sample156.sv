module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

integer i, j;
integer neighbor_count;
reg [255:0] next_q;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_q;
    end
end

always @(*) begin
    next_q = q_reg;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbor_count = 0;
            for (integer k = -1; k <= 1; k = k + 1) begin
                for (integer l = -1; l <= 1; l = l + 1) begin
                    if (k == 0 && l == 0) begin
                        continue;
                    end
                    integer row = (i + k + 16) % 16;
                    integer col = (j + l + 16) % 16;
                    if (q_reg[(row * 16) + col]) begin
                        neighbor_count = neighbor_count + 1;
                    end
                end
            end
            if (neighbor_count <= 1) begin
                next_q[(i * 16) + j] = 1'b0;
            end else if (neighbor_count == 2) begin
                next_q[(i * 16) + j] = q_reg[(i * 16) + j];
            end else if (neighbor_count == 3) begin
                next_q[(i * 16) + j] = 1'b1;
            end else begin
                next_q[(i * 16) + j] = 1'b0;
            end
        end
    end
end

assign q = q_reg;

endmodule