module TopModule(
    input clk,
    input load,
    input logic [255:0] data,
    output logic [255:0] q
);

logic [255:0] current_state;

// Sequential logic to update the state of each cell
always_ff @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        logic [255:0] next_state;
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
            if ((alive_neighbors == 3) || (alive_neighbors == 2 && current_state[i])) begin
                next_state[i] = 1'b1;
            end else begin
                next_state[i] = 1'b0;
            end
        end
        current_state <= next_state;
    end
end

// Output logic
assign q = current_state;

endmodule