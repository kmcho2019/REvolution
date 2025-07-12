module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] grid;
reg [255:0] next_grid;
reg [3:0] neighbours [15:0][15:0];

// Game rules lookup table
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
                            continue;
                        end
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
                neighbours[i][j] = count;
                reg [3:0] count_case;
                count_case = neighbours[i][j];
                case (count_case)
                    4'd0, 4'd1: next_grid[(i * 16) + j] <= 1'b0;
                    4'd2: next_grid[(i * 16) + j] <= grid[(i * 16) + j];
                    4'd3: next_grid[(i * 16) + j] <= 1'b1;
                    default: next_grid[(i * 16) + j] <= 1'b0;
                endcase
            end
        end
        grid <= next_grid;
    end
    q <= grid;
end

endmodule