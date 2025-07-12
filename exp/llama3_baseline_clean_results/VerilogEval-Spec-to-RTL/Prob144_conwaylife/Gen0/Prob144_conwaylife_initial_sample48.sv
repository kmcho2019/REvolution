module TopModule(
    input  clk,
    input  load,
    input  [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;
integer row, col;

always @(*) begin
    next_state = current_state;
    for (i = 0; i < 256; i++) begin
        row = i / 16;
        col = i % 16;
        reg [2:0] neighbors;
        neighbors = 0;

        for (j = -1; j <= 1; j++) begin
            for (integer k = -1; k <= 1; k++) begin
                if ((j != 0 || k != 0) && current_state[((((row + j + 16) % 16) * 16) + (col + k + 16) % 16)]) begin
                    neighbors = neighbors + 1;
                end
            end
        end

        if (neighbors == 0 || neighbors == 1) begin
            next_state[i] = 0;
        end else if (neighbors == 3) begin
            next_state[i] = 1;
        end else if (neighbors >= 4) begin
            next_state[i] = 0;
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state = data;
    end else begin
        current_state = next_state;
    end
end

assign q = current_state;

endmodule