module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;
integer neighbors;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = current_state;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            neighbors = 0;
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if (x == 0 && y == 0) continue;
                    integer pos_x = (i + x + 16) % 16;
                    integer pos_y = (j + y + 16) % 16;
                    integer index = pos_x * 16 + pos_y;
                    if (current_state[index]) neighbors = neighbors + 1;
                end
            end
            integer index = i * 16 + j;
            if (neighbors <= 1 || neighbors >= 4) begin
                next_state[index] = 0;
            end else if (neighbors == 3) begin
                next_state[index] = 1;
            end
        end
    end
end

assign q = current_state;

endmodule