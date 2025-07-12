module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
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

always @(*) begin
    next_state = 256'b0;
    for (int i = 0; i < 16; i++) begin
        for (int j = 0; j < 16; j++) begin
            wire alive_neighbors = count_alive_neighbors(i, j, current_state);
            wire cell_state = current_state[(i * 16) + j];
            case (alive_neighbors)
                2'b00, 2'b01: next_state[(i * 16) + j] = 1'b0;
                2'b10: next_state[(i * 16) + j] = cell_state;
                2'b11: next_state[(i * 16) + j] = 1'b1;
                default: next_state[(i * 16) + j] = 1'b0;
            endcase
        end
    end
end

function wire [1:0] count_alive_neighbors;
    input [4:0] i;
    input [4:0] j;
    input [255:0] state;
    reg [2:0] alive_neighbors;

    alive_neighbors = 3'b000;
    for (int x = -1; x <= 1; x++) begin
        for (int y = -1; y <= 1; y++) begin
            if ((x == 0) && (y == 0)) begin
                continue;
            end
            wire cell_state = state[((((i + x) % 16) * 16) + ((j + y) % 16))];
            if (cell_state) begin
                alive_neighbors = alive_neighbors + 1'b1;
            end
        end
    end

    if (alive_neighbors > 3) begin
        count_alive_neighbors = 2'b00;
    end else if (alive_neighbors == 3) begin
        count_alive_neighbors = 2'b11;
    end else if (alive_neighbors == 2) begin
        count_alive_neighbors = 2'b10;
    end else begin
        count_alive_neighbors = 2'b00;
    end
endfunction

assign q = current_state;

endmodule