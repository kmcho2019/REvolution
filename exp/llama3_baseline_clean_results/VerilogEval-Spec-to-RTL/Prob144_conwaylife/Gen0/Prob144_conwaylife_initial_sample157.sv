module TopModule (
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j, x, y;
integer alive_neighbors;

always @(*) begin
    for (i = 0; i < 256; i++) begin
        alive_neighbors = 0;
        for (x = -1; x <= 1; x++) begin
            for (y = -1; y <= 1; y++) begin
                if (x == 0 && y == 0) continue;
                j = ((i / 16) + x + 16) % 16 * 16 + (i % 16 + y + 16) % 16;
                if (current_state[j]) alive_neighbors++;
            end
        end
        if (alive_neighbors <= 1 || alive_neighbors >= 4) begin
            next_state[i] = 0;
        end else if (alive_neighbors == 2) begin
            next_state[i] = current_state[i];
        end else if (alive_neighbors == 3) begin
            next_state[i] = 1;
        end
    end
end

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

assign q = current_state;

endmodule