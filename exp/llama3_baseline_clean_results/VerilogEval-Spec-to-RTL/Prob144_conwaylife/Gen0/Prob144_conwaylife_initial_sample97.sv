module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] q_reg;

always @(posedge clk) begin
    if (load) begin
        q_reg <= data;
    end else begin
        reg [255:0] next_state;
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [2:0] neighbors;
                neighbors = 0;
                for (int k = -1; k <= 1; k++) begin
                    for (int l = -1; l <= 1; l++) begin
                        if (k == 0 && l == 0) continue;
                        reg [3:0] row, col;
                        row = (i + k + 16) % 16;
                        col = (j + l + 16) % 16;
                        reg index;
                        index = row * 16 + col;
                        if (q_reg[index]) neighbors <= neighbors + 1;
                    end
                end
                if (neighbors < 2 || neighbors > 3) next_state[i * 16 + j] <= 0;
                else if (neighbors == 3) next_state[i * 16 + j] <= 1;
                else next_state[i * 16 + j] <= q_reg[i * 16 + j];
            end
        end
        q_reg <= next_state;
    end
end

assign q = q_reg;

endmodule