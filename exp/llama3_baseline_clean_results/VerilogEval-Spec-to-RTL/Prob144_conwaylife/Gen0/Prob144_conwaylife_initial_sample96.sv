module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;
reg [255:0] next_q;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        q_reg <= next_q;
    end
end

always @(*) begin
    next_q = 256'd0;
    for (i = 0; i < 16; i++) begin
        for (j = 0; j < 16; j++) begin
            integer num_neighbours;
            num_neighbours = 0;
            for (integer x = -1; x <= 1; x++) begin
                for (integer y = -1; y <= 1; y++) begin
                    if (x == 0 && y == 0) continue;
                    integer row, col;
                    row = (i + x + 16) % 16;
                    col = (j + y + 16) % 16;
                    if (q_reg[row*16 + col]) num_neighbours++;
                end
            end
            if (q_reg[i*16 + j] == 1'b1) begin
                if (num_neighbours == 2 || num_neighbours == 3) begin
                    next_q[i*16 + j] = 1'b1;
                end else begin
                    next_q[i*16 + j] = 1'b0;
                end
            end else begin
                if (num_neighbours == 3) begin
                    next_q[i*16 + j] = 1'b1;
                end else begin
                    next_q[i*16 + j] = 1'b0;
                end
            end
        end
    end
end

assign q = q_reg;

endmodule