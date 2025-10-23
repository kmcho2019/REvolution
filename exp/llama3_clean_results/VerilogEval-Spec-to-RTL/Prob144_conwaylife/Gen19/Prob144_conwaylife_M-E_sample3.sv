module alive_neighbors(
    input [255:0] current_state,
    input [7:0] cell_index,
    output reg [3:0] alive_count
);

reg [3:0] count;
reg [7:0] row, col, neighbor_row, neighbor_col;
reg [7:0] neighbor_index;

always @(*) begin
    count = 0;
    row = cell_index / 16;
    col = cell_index % 16;
    for (int x = -1; x <= 1; x = x + 1) begin
        for (int y = -1; y <= 1; y = y + 1) begin
            if (x != 0 || y != 0) begin
                neighbor_row = (row + x + 16) % 16;
                neighbor_col = (col + y + 16) % 16;
                neighbor_index = (neighbor_row * 16) + neighbor_col;
                if (current_state[neighbor_index]) begin
                    count = count + 1;
                end
            end
        end
    end
    alive_count = count;
end

endmodule

module update_cell(
    input current_state,
    input [3:0] alive_count,
    output reg next_state
);

always @(*) begin
    if (alive_count == 3 || (alive_count == 2 && current_state)) begin
        next_state = 1'b1;
    end else begin
        next_state = 1'b0;
    end
end

endmodule

module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

alive_neighbors alive_neighbors_module[255:0](
    .current_state(current_state),
    .cell_index(8'd0)
);

update_cell update_cell_module[255:0](
    .current_state(current_state[8'd0]),
    .alive_count(alive_neighbors_module[8'd0].alive_count)
);

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    for (int i = 0; i < 256; i = i + 1) begin
        alive_neighbors_module[i].cell_index = i;
        update_cell_module[i].current_state = current_state[i];
        update_cell_module[i].alive_count = alive_neighbors_module[i].alive_count;
        next_state[i] = update_cell_module[i].next_state;
    end
    q = current_state;
end

endmodule