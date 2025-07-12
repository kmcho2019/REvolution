// TopModule
module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output reg [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;
reg [7:0] row;
reg [3:0] col;
reg [2:0] alive_neighbors;

// Load current state
always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

// Pipeline stage 1: Calculate alive neighbors
wire [2:0] alive_neighbors_out;
always @(posedge clk) begin
    for (row = 0; row < 16; row = row + 1) begin
        for (col = 0; col < 16; col = col + 1) begin
            reg [7:0] index = (row * 16) + col;
            reg [2:0] alive_neighbors = 0;
            for (reg [1:0] x = 0; x < 3; x = x + 1) begin
                for (reg [1:0] y = 0; y < 3; y = y + 1) begin
                    if (x != 1 || y != 1) begin
                        reg [3:0] x_index = (row + x - 1 + 16) % 16;
                        reg [3:0] y_index = (col + y - 1 + 16) % 16;
                        reg [7:0] neighbor_index = (x_index * 16) + y_index;
                        if (current_state[neighbor_index]) begin
                            alive_neighbors = alive_neighbors + 1;
                        end
                    end
                end
            end
            assign alive_neighbors_out = alive_neighbors;
        end
    end
end

// Pipeline stage 2: Update next state
always @(posedge clk) begin
    for (row = 0; row < 16; row = row + 1) begin
        for (col = 0; col < 16; col = col + 1) begin
            reg [7:0] index = (row * 16) + col;
            if (alive_neighbors_out == 3 || (alive_neighbors_out == 2 && current_state[index])) begin
                next_state[index] <= 1;
            end else begin
                next_state[index] <= 0;
            end
        end
    end
end

// Pipeline stage 3: Store updated state
always @(posedge clk) begin
    q <= next_state;
end

endmodule