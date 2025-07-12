module TopModule(
    input clk,
    input load,
    input logic [255:0] data,
    output logic [255:0] q
);

logic [255:0] current_state;
logic [255:0] next_state;

// Pipeline registers
logic [255:0] neighbor_count;
logic [255:0] game_logic_output;

// Stage 1: Neighbor Count
always_comb begin
    for (int i = 0; i < 256; i++) begin
        logic [2:0] alive_neighbors = 0;
        for (int x = -1; x <= 1; x++) begin
            for (int y = -1; y <= 1; y++) begin
                if (x != 0 || y != 0) begin
                    int row = (i / 16) + x;
                    int col = (i % 16) + y;
                    row = (row + 16) % 16;
                    col = (col + 16) % 16;
                    int neighbor_index = (row * 16) + col;
                    if (current_state[neighbor_index]) begin
                        alive_neighbors += 1;
                    end
                end
            end
        end
        neighbor_count[i] = alive_neighbors;
    end
end

// Stage 2: Game Logic
always_comb begin
    for (int i = 0; i < 256; i++) begin
        if ((neighbor_count[i] == 3) || (neighbor_count[i] == 2 && current_state[i])) begin
            game_logic_output[i] = 1'b1;
        end else begin
            game_logic_output[i] = 1'b0;
        end
    end
end

// Stage 3: State Update
always_ff @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= game_logic_output;
    end
end

// Output logic
assign q = current_state;

endmodule