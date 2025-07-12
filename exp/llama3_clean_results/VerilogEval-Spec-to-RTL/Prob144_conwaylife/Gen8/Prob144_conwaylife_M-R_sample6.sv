module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;
reg [3:0] neighbours [15:0][15:0];
reg [1:0] game_rules [3:0];

initial begin
    // Initialize game rules lookup table
    game_rules[0] = 2'b00; // 0-1 neighbour: Cell becomes 0
    game_rules[1] = 2'b00; // 1 neighbour: Cell becomes 0
    game_rules[2] = 2'b01; // 2 neighbours: Cell state does not change
    game_rules[3] = 2'b10; // 3 neighbours: Cell becomes 1
end

// Update grid state
always @(posedge clk) begin
    if (load) begin
        grid <= data;
    end else begin
        for (int i = 0; i < 16; i++) begin
            for (int j = 0; j < 16; j++) begin
                reg [3:0] count;
                count = 0;
                for (int x = -1; x <= 1; x++) begin
                    for (int y = -1; y <= 1; y++) begin
                        if ((x == 0) && (y == 0)) begin
                            // Do nothing
                        end else begin
                            reg [7:0] new_i;
                            reg [7:0] new_j;
                            new_i = (i + x + 16) % 16;
                            new_j = (j + y + 16) % 16;
                            reg index;
                            index = (new_i * 16) + new_j;
                            if (grid[index]) begin
                                count = count + 1;
                            end
                        end
                    end
                end
                neighbours[i][j] = count;
                reg [1:0] next_state;
                if (count == 0 || count == 1) begin
                    next_state = 2'b00; // Cell becomes 0
                end else if (count == 2) begin
                    next_state = 2'b01; // Cell state does not change
                end else if (count == 3) begin
                    next_state = 2'b10; // Cell becomes 1
                end else begin
                    next_state = 2'b00; // Cell becomes 0
                end
                next_grid[(i * 16) + j] <= (next_state[1] ? 1'b1 : (next_state[0] ? grid[(i * 16) + j] : 1'b0));
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule