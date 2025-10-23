module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
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

integer i, x, y;
reg [3:0] alive_neighbors;
reg [4:0] row, col;
reg [7:0] neighbor_index;

always @(*) begin
    next_state = 256'b0;
    for (i = 0; i < 256; i = i + 1) begin
        alive_neighbors = 0;
        for (x = -1; x <= 1; x = x + 1) begin
            for (y = -1; y <= 1; y = y + 1) begin
                if (x != 0 || y != 0) begin
                    row = (i / 16) + x;
                    col = (i % 16) + y;
                    row = row < 0 ? 15 : row > 15 ? 0 : row;
                    col = col < 0 ? 15 : col > 15 ? 0 : col;
                    neighbor_index = row * 16 + col;
                    if (current_state[neighbor_index]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
        end
        if ((alive_neighbors == 3) || (alive_neighbors == 2 && current_state[i])) begin
            next_state[i] = 1'b1;
        end 
    end
end

assign q = current_state;

endmodule