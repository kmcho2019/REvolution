// Function to calculate the number of alive neighbors for a cell
function int calculate_alive_neighbors;
    input [255:0] current_state;
    input int cell_index;
    begin
        int alive_neighbors = 0;
        for (int x = -1; x <= 1; x = x + 1) begin
            for (int y = -1; y <= 1; y = y + 1) begin
                if (x!= 0 || y!= 0) begin
                    int row = (cell_index / 16) + x;
                    int col = (cell_index % 16) + y;
                    row = (row + 16) % 16;
                    col = (col + 16) % 16;
                    int neighbor_index = (row * 16) + col;
                    if (current_state[neighbor_index]) begin
                        alive_neighbors = alive_neighbors + 1;
                    end
                end
            end
        end
        calculate_alive_neighbors = alive_neighbors;
    end
endfunction

module TopModule(
    input clk,
    input reset,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;

// Combinational logic to calculate the number of alive neighbors for each cell
always @(*) begin
    reg [255:0] next_state;
    for (int i = 0; i < 256; i = i + 1) begin
        int alive_neighbors = calculate_alive_neighbors(current_state, i);
        if ((alive_neighbors == 3) || (alive_neighbors == 2 && current_state[i])) begin
            next_state[i] = 1'b1;
        end else begin
            next_state[i] = 1'b0;
        end
    end
    if (load) begin
        q = data;
    end else begin
        q = next_state;
    end
end

// Sequential logic to update the state of each cell
always @(posedge clk) begin
    if (reset) begin
        current_state <= 256'b0;
    end else if (load) begin
        current_state <= data;
    end else begin
        current_state <= q;
    end
end

endmodule