module TopModule(
    input clk,
    input load,
    input [255:0] data,
    output [255:0] q
);

reg [255:0] current_state;
reg [255:0] next_state;

integer i, j;

always @(posedge clk) begin
    if (load) begin
        current_state <= data;
    end else begin
        current_state <= next_state;
    end
end

always @(*) begin
    next_state = 256'b0;
    for (i = 0; i < 16; i = i + 1) begin
        for (j = 0; j < 16; j = j + 1) begin
            reg [2:0] neighbours;
            neighbours = 3'b0;
            for (integer x = -1; x <= 1; x = x + 1) begin
                for (integer y = -1; y <= 1; y = y + 1) begin
                    if ((x == 0) && (y == 0)) begin
                        // Do not count the cell itself as a neighbour
                        continue;
                    end
                    integer neighbour_x, neighbour_y;
                    neighbour_x = (i + x + 16) % 16;
                    neighbour_y = (j + y + 16) % 16;
                    if (current_state[neighbour_y + neighbour_x * 16]) begin
                        neighbours = neighbours + 1;
                    end
                end
            end
            integer cell_index;
            cell_index = j + i * 16;
            if ((neighbours == 3) || ((neighbours == 2) && current_state[cell_index])) begin
                next_state[cell_index] = 1'b1;
            end else begin
                next_state[cell_index] = 1'b0;
            end
        end
    end
end

assign q = current_state;

endmodule